local watch = require("awful.widget.watch")
local wibox = require("wibox")


local cpu_widget = {}

local function worker(user_args)
    local args = user_args or {}
    local timeout = args.timeout or 3

    cpu_widget = wibox.widget {
        {
            id = 'icon',
            markup = ' ',
            font = 'Material Icons, 12',
            widget = wibox.widget.textbox
        },
        {
            id = 'cpu',
            markup = '0',
            font = 'Droid Sans, Bold 9',
            widget = wibox.widget.textbox
        },
        {
            id = 'cpu_temp',
            markup = '0',
            font = 'Droid Sans, Bold 9',
            widget = wibox.widget.textbox
        },
        forced_width = 75,
        layout = wibox.layout.fixed.horizontal
    }

    local cmd_averrage_load = [[bash -c "vmstat 1 2|tail -1|awk '{print $15}'"]]
    local cmd_averrage_temp = [[bash -c "sensors | grep \"Package id 0\" | cut -c17-20"]]
    watch(cmd_averrage_load, timeout,
        function(widget, stdout)
            if (math.floor(stdout) == 0) then
                widget.forced_width = 85
            else
                widget.forced_width = 75
            end
            widget.cpu.markup = math.floor(100 - stdout) .. "%"
        end,
        cpu_widget
    )

    watch(cmd_averrage_temp, timeout,
        function(widget, stdout)
            local temp = math.floor(stdout)
            widget.cpu_temp.markup = " " .. temp .. "°C "
            widget.icon.markup = '<span color="' .. fade_RGB("#FF0000", "#00FF00", 120 - temp) .. '"> </span>'

        end,
        cpu_widget
    )
    return cpu_widget
end

return setmetatable(cpu_widget, { __call = function(_, ...)
    return worker(...)
end })
