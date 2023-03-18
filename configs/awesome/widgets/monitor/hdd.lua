local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local watch = require("awful.widget.watch")
local wibox = require("wibox")


local hdd_widget = {}

local function worker(user_args)
    local args = user_args or {}
    local timeout = args.timeout or 1

    hdd_widget = wibox.widget {
        {
            id = 'icon',
            markup = ' ',
            font = 'Material Icons, 11',
            widget = wibox.widget.textbox
        },
        {
            id = 'hdd',
            markup = '0',
            font = 'Droid Sans, Bold 9',
            widget = wibox.widget.textbox
        },

        layout = wibox.layout.fixed.horizontal
    }

    local cmd_hdd_used = [[bash -c  "df -Pk . | sed 1d | grep -v used | awk '{ print $5 }'"]]
    watch(cmd_hdd_used, timeout,
        function(widget, stdout)
            local used_percent = math.floor(string.gsub(stdout, "%p", ""))
            widget.hdd.markup = used_percent .. "%" .. " "
            widget.icon.markup = '<span color="' .. fade_RGB("#FF0000", "#00FF00", 110 - used_percent) .. '"> </span>'
        end,
        hdd_widget
    )
    return hdd_widget
end

return setmetatable(hdd_widget, { __call = function(_, ...)
    return worker(...)
end })
