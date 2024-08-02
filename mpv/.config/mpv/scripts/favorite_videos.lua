local utils = require "mp.utils"

local FAVORITES_FILE = ".favorites.txt"
local WATCHED_FILE = ".watched.txt"
local DELETE_FILE = ".delete.txt"

local CURRENT_PATH = ""
local CURRENT_DIR = ""
local CURRENT_NAME = ""

local function append_file(filename, str)
    local file = io.open(filename, "a")
    file:write(str)
    file:close()
end

local function append_video_to_file(file)
    local path = CURRENT_PATH
    local name = CURRENT_NAME
    append_file(file, string.format("%s\n", path))
    mp.osd_message(string.format("'%s'\n >> %s", name, file))
    print(string.format("[INFO] '%s' >> %s", name, file))
end

local function append_favorite()
    append_video_to_file(FAVORITES_FILE)
end

local function append_watched()
    append_video_to_file(WATCHED_FILE)
end

local function append_delete()
    append_video_to_file(DELETE_FILE)
end

local function on_load(event)
    CURRENT_PATH = mp.get_property("path")
    CURRENT_DIR, CURRENT_NAME = utils.split_path(CURRENT_PATH)
    print(string.format("[INFO] Current open video path: '%s'", CURRENT_PATH))
end

local function on_end(event)
    if event["reason"] == "stop" then
        append_watched()
    else
        print(string.format("[INFO] End reason: '%s'", event["reason"]))
    end
end

-- KEYBINDS
mp.add_key_binding("Ctrl+f", "append_favorite", append_favorite)
mp.add_key_binding("Ctrl+SPACE", "append_watched", append_watched)
mp.add_key_binding("Ctrl+Shift+d", "append_delete", append_delete)

-- Cache file information on load
mp.register_event("file-loaded", on_load)

-- Split on exit as well
mp.register_event("end-file", on_end)
