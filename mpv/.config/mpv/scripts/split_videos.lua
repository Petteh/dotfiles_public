require 'mp'
require 'os'
local utils = require "mp.utils"

local TS_FILE = ".timestamps.txt"

-- Buffers
local TIMES = {}
local TS_BUF = ""
local VID_INFO = {}


local function divmod(a, b)
    return a / b, a % b
end

local function get_osd_timestamp(time_pos)
    local minutes, remainder = divmod(time_pos, 60)
    local hours, minutes = divmod(minutes, 60)
    local seconds = math.floor(remainder)
    -- local milliseconds = math.floor((remainder - seconds) * 1000)
    local time = string.format("%02d:%02d:%02d", hours, minutes, seconds)
    return time
end

local function get_timestamp(time_pos)
    local minutes, remainder = divmod(time_pos, 60)
    local hours, minutes = divmod(minutes, 60)
    local seconds = math.floor(remainder)

    timestamp = string.format("%02d%02d%02d", hours, minutes, seconds)
    return timestamp
end

local function get_separator(num_timestamps)
    if num_timestamps % 2 == 1 then
        separator = " - "
    else
        separator = "\n"
    end
    return separator
end

local function get_vid_info()
    local vid_info = {}
    local path = mp.get_property("path")
    vid_info.path = path
    vid_info.dirname = utils.split_path(path)
    vid_info.filename = mp.get_property("filename")
    vid_info.name = mp.get_property("filename/no-ext")
    vid_info.ext = mp.get_property("filename"):match("^.+(%..+)$") or ".mp4"
    return vid_info
end

local function update_vid_info()
    if not next(VID_INFO) then
        VID_INFO = get_vid_info()
    end
end

local function update_ts_buf(time, num_timestamps)
    local separator = get_separator(num_timestamps)
    TS_BUF = string.format("%s%s%s", TS_BUF, get_osd_timestamp(time), separator)
end

local function store_time()
    update_vid_info() -- We treat this as an action we have taken

    local time = mp.get_property_number("time-pos")
    -- print(string.format("[DEBUG] Current time in video: %05.02f", time))

    table.insert(TIMES, time)
    update_ts_buf(time, #TIMES)
    mp.osd_message(TS_BUF)
end

local function undo_time()
    print("[INFO] Undo timestamp")
    table.remove(TIMES)
    -- Reconstruct TS_BUF
    TS_BUF = ""
    for i, time in ipairs(TIMES) do
        update_ts_buf(time, i)
    end
    mp.osd_message(TS_BUF)
end

local function split_video(vid_info, start, stop)
    local split_name = vid_info.name .. "_splits_" .. get_timestamp(start) .. "-" .. get_timestamp(stop) .. vid_info.ext
    local split_path = utils.join_path(vid_info.dirname, split_name)
    local duration = stop - start

    local cmd = string.format(
        "ffmpeg -nostdin -y -loglevel error -ss %s -t %s -i '%s' -map 0 -c:v copy -c:a copy -c:s copy -avoid_negative_ts make_zero %s",
        tostring(start), tostring(duration),
        vid_info.path,
        split_path
    )
    print(string.format("[INFO] Running cmd: '%s'", cmd))

    -- https://github.com/mpv-player/mpv/blob/master/DOCS/man/lua.rst#mp-functions
    mp.commandv("run",
        "ffmpeg",
        "-nostdin", "-y", "-loglevel", "error",
        "-ss", tostring(start),
        "-t", tostring(duration),
        "-i", vid_info.path,
        "-map", "0",
        "-c:v", "copy",
        "-c:a", "copy",
        "-c:s", "copy",
        "-avoid_negative_ts", "make_zero",
        split_path
    )
end

local function is_start(i)
    return i % 2 == 1
end

local function split_all()
    if not next(VID_INFO) then
        return
    end
    local vid_info = VID_INFO

    local start = 0
    local stop = 0
    for i, time in ipairs(TIMES) do
        if is_start(i) then
            start = time
            stop = 0
        else
            stop = time
            split_video(vid_info, start, stop)
        end
    end
    if stop == 0 then
        print("[WARNING] Missing 'STOP' timestamp")
    end
end

local function append_file(filename, str)
    local file = io.open(filename, "a")
    file:write(str)
    file:close()
end

local function reset()
    TIMES = {}
    TS_BUF = ""
    VID_INFO = {}
end

local function write_timestamps(vid_info)
    local timestamps_file = utils.join_path(vid_info.dirname, TS_FILE)
    append_file(timestamps_file, string.format("%s\n", vid_info.filename))
    local start = 0.0
    for i, time in ipairs(TIMES) do
        if is_start(i) then
            start = time
        else
            append_file(timestamps_file, string.format("\t%f %f\n", start, time))
        end
    end
    append_file(timestamps_file, "\n")
end

local function on_end_split_videos_write_timestamps(event)
    if not next(VID_INFO) then
        reset()
        return
    end

    split_all()
    local vid_info = VID_INFO
    write_timestamps(vid_info)

    reset()
end

local function c_key_handler()
    store_time()
end

local function middle_mouse_button_handler()
    store_time()
end

mp.add_key_binding("c", "c_key_store_time", c_key_handler)
mp.add_key_binding("MBTN_MID", "middle_mouse_button_store_time", middle_mouse_button_handler)
mp.add_key_binding("ctrl+z", "undo_time", undo_time)

mp.add_key_binding("C", "split_all", split_all)

-- Split on exit as well
mp.register_event('end-file', on_end_split_videos_write_timestamps)
