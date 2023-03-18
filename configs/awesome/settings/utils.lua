local awful = require("awful")
local awful_old = require('awful')
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")

local naughty = require("naughty")

if awesome.startup_errors then
    naughty.notify({
        preset = naughty.config.presets.critical,
        title = "Oops, there were errors during startup!",
        text = awesome.startup_errors
    })
end

-- Вывод ошибок после запускау
do
    local in_error = false
    awesome.connect_signal("debug::error", function(err)
        -- Make sure we don't go into an endless error loop
        if in_error then
            return
        end
        in_error = true

        naughty.notify({
            preset = naughty.config.presets.critical,
            title = "Oops, an error happened!",
            text = tostring(err)
        })
        in_error = false
    end)
end

function pprint(text)
    naughty.notify({
        preset = naughty.config.presets.info,
        title = tostring(text)
    })
end

GET_FILE_PATH = function()
    return debug.getinfo(2).source:match("@?(.*/)")
end


function split(string_to_split, separator)
    if separator == nil then
        separator = "%s"
    end
    local t = {}

    for str in string.gmatch(string_to_split, "([^" .. separator .. "]+)") do
        table.insert(t, str)
    end

    return t
end

require('settings.utils.table_widget')
require('settings.utils.linear_color')