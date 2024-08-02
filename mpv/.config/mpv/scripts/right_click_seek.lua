require 'mp'

SEEK_ACTIVE = false

local function get_mouse_pos_ratio()
    local x, _ = mp.get_mouse_pos()
    local x_res = mp.get_property_number("osd-width")
    return x / x_res
end

local function seek_to(time)
    mp.commandv("osd-bar", "seek", time, "absolute")
end

local function seek_to_mouse_pos()
    local mouse_pos_ratio = get_mouse_pos_ratio()

    local duration = mp.get_property_number("duration")
    if duration == nil then
        duration = 0
    end

    local seek_time = duration * mouse_pos_ratio
    seek_to(seek_time)
end

local function right_click_handler(info)
    local event = info["event"]
    if event == "press" or event == "down" then
        SEEK_ACTIVE = true
    elseif event == "up" then
        SEEK_ACTIVE = false
    else
        mp.osd_message("WARNING! Something other than 'press', 'down' or 'up' given by right click event")
        print("WARNING! Something other than 'down' or 'up' given by right click event")
        print("info['event']:", event)
        SEEK_ACTIVE = false
        return
    end

    seek_to_mouse_pos()
end

local function seek_handler()
    if SEEK_ACTIVE then
        seek_to_mouse_pos()
    end
end

local function right_double_click_handler()
    seek_to_mouse_pos()
end

mp.add_key_binding("MBTN_RIGHT", "right_click_handler", right_click_handler, {repeatable = false, complex = true})
mp.add_key_binding("MBTN_RIGHT_DBL", "", right_double_click_handler)
mp.register_event("seek", seek_handler)
