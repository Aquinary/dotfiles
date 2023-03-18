local awful = require("awful")
local watch = require("awful.widget.watch")
local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")

local function popup_create(widget, timeout)
    local function table_normalize(table)
        local temp_table = {}
        local iter = 1;
        for k, v in pairs(table) do
            temp_table[iter] = {k, v}
            iter = iter + 1
        end
      
        return temp_table
      end
    local caption = {
        layout = wibox.layout.fixed.vertical
    }

    local rows = {
        layout = wibox.layout.fixed.vertical
    }

    local popup = awful.popup {
        ontop = true,
        visible = false,

        border_width = 1,
        border_color = beautiful.bg_normal,
        maximum_width = 350,
        forced_height = 100,
        offset = {
            y = 4
        },
        widget = {}
    }

    popup:setup{
        {
            {
                {
                    text = 'Calculating...',
                    align = 'center',
                    forced_width = 90,
                    forced_height = 20,
                    widget = wibox.widget.textbox
                },
                layout = wibox.layout.ratio.horizontal
            },
            layout = wibox.layout.fixed.vertical
        },
        margins = 8,
        widget = wibox.container.margin
    }

    local popup_timer = gears.timer {
        timeout = timeout
    }

    widget:connect_signal("mouse::enter", function()
        popup:move_next_to(mouse.current_widget_geometry)
        popup_timer:start()
        popup_timer:emit_signal("timeout")
    end)
    widget:connect_signal("mouse::leave", function()
        popup.visible = not popup.visible
        popup_timer:stop()
    end)

    

    popup_timer:connect_signal('timeout', function()
        awful.spawn.easy_async([[ bash -c "smem -c 'name uss pss rss' -p -H"]], function(stdout, _, _, _)
            local row_counter = 1

            local process_table = {}

            for line in stdout:gmatch("[^\r\n]+") do

                local sp = split(line, " ")

                local process = sp[1]
                local uss = string.gsub(sp[2], "%%", "")
                local pss = string.gsub(sp[3], "%%", "")
                local rss = string.gsub(sp[4], "%%", "")

                if process_table[process] == nil then
                    process_table[process] = {uss, pss, rss}
                else
                    process_table[process][1] = process_table[process][1] + uss
                    process_table[process][2] = process_table[process][2] + pss
                    process_table[process][3] = process_table[process][3] + rss
                end
            end

            process_table = table_normalize(process_table)
            table.sort(process_table, function(a, b)
                return tonumber(a[2][2]) > tonumber(b[2][2])
            end)

            local count = 1
            for k, v in pairs(process_table) do
                if count <= 15 then
                    rows[row_counter] = table_widget_create {
                        rows = {v[1], v[2][1] .. '%', v[2][2] .. '%', v[2][3] .. '%'}
                    }
                    row_counter = row_counter + 1
                end
                count = count + 1
            end

            popup:setup{
                {
                    table_widget_create {
                        rows = {'Process', 'USS', 'PSS', 'RSS'},
                        is_bold = true
                    },

                    {
                        orientation = 'horizontal',
                        forced_height = 15,
                        color = beautiful.bg_focus,
                        widget = wibox.widget.separator
                    },
                    rows,
                    layout = wibox.layout.fixed.vertical
                },
                margins = 8,
                widget = wibox.container.margin
            }
        end)
    end)
end

local ram_widget = {}

local function worker(user_args)
    local args = user_args or {}
    local timeout = args.timeout or 3

    ram_widget = wibox.widget {
        {
            id = 'icon',
            markup = ' ',
            font = 'Material Icons, 12',
            widget = wibox.widget.textbox
        },
        {
            id = 'ram',
            markup = '0',
            font = 'Droid Sans, Bold 9',
            widget = wibox.widget.textbox
        },
        layout = wibox.layout.fixed.horizontal
    }

    local ram_cmd = [[bash -c "free | grep -w Mem | awk '{ print $2, $7}'"]]
    watch(ram_cmd, timeout, function(widget, stdout)

        local total = tonumber(split(stdout, " ")[1])
        local available = tonumber(split(stdout, " ")[2])
        local used = total - available
        local used_percent = math.floor(used / total * 100)

        widget.ram.markup = used_percent .. "%"
        widget.icon.markup = '<span color="' .. fade_RGB("#FF0000", "#00FF00", 110 - used_percent) .. '"> </span>'

    end, ram_widget)

    popup_create(ram_widget, timeout)
    return ram_widget
end

return setmetatable(ram_widget, {
    __call = function(_, ...)
        return worker(...)
    end
})
