local awful = require("awful")
local wibox = require("wibox")
local fs_widget = require("widgets.monitor.fs")

function require_panel(s)
    s.panel = awful.wibar({ position = "top", screen = s, height = 30, bg = "#000000" })

    s.panel:setup {
        layout = wibox.layout.align.horizontal,
        {
            layout = wibox.layout.fixed.horizontal,
            widgets.taglist,
            widgets.separator,
            widgets.tasklist,
        },
        nil,
        {
            layout = wibox.layout.fixed.horizontal,
            widgets.monitor[1],
            widgets.separator,
            widgets.monitor[2],
            widgets.separator,
            widgets.monitor[3],
            widgets.separator,
            widgets.monitor[4],
            widgets.separator,
            widgets.datetime,
            widgets.separator,
            widgets.systray,
            widgets.keyboard,
            widgets.layoutbox,
        }
    }
end
