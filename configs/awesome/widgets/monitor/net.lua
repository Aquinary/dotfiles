local awful = require("awful")
local watch = require("awful.widget.watch")
local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")

local function popup_create(widget, timeout)
    local caption = {
        layout = wibox.layout.fixed.vertical
    }
    local top_rows = {
        layout = wibox.layout.fixed.vertical
    }
    local bottom_rows = {
        layout = wibox.layout.fixed.vertical
    }

    local popup_timer = gears.timer {
        timeout = timeout
    }

    local popup = awful.popup {
        ontop = true,
        visible = false,

        border_width = 1,
        border_color = beautiful.bg_normal,
        maximum_width = 365,
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
        awful.spawn.easy_async([[bash -c "vnstat -d; vnstat -m 1; vnstat -y 1"]], function(stdout, _, _, _)

            -- проходим по всем строкам
            local t_counter = 1
            local b_counter = 1
            local now_day = true
            local dates = {}

            for line in stdout:gmatch("[^\r\n]+") do

                -- формируем полный список дней/месяц и год
                if string.match(line, "%d%d%d%d") then
                    table.insert(dates, line)
                end
            end

            for date = #dates, 1, -1 do
                local columns = split(dates[date], '|')
                local time_and_rx = columns[1]
    
                -- вывод дней
                local time = split(time_and_rx, " ")[1]
                local rx = split(time_and_rx, " ")[2] .. split(time_and_rx, " ")[3]
                local tx = string.gsub(columns[2], " ", "")
                local total = columns[3]
                -- дни
                local length = #split(dates[date], '-')
                if length == 3 then
                    if now_day == false then
                        if b_counter <= 15 then
                            bottom_rows[b_counter] = table_widget_create {
                                rows = {time, rx, tx, total}
                            }
                            b_counter = b_counter + 1
                        end

                    else
                        -- за сегодня
                        top_rows[t_counter] = table_widget_create {
                            rows = {'Today', rx, tx, total}
                        }
                        t_counter = t_counter - 1

                        now_day = false
                    end
                end
                -- за месяц
                if length == 2 then
                    top_rows[t_counter] = table_widget_create {
                        rows = {'Month', rx, tx, total}
                    }
                    t_counter = t_counter - 1
                end
                -- за год
                if length == 1 then
                    top_rows[t_counter] = table_widget_create {
                        rows = {"Year", rx, tx, total}
                    }
                    t_counter = t_counter - 1
                end
            end

            popup:setup{
                {
                    table_widget_create {
                        rows = {'Date', 'Rx', 'Tx', 'Total'},
                        is_bold = true
                    },
                    {
                        orientation = 'horizontal',
                        forced_height = 15,
                        color = beautiful.bg_focus,
                        widget = wibox.widget.separator
                    },
                    top_rows,
                    {
                        orientation = 'horizontal',
                        forced_height = 15,
                        color = beautiful.bg_focus,
                        widget = wibox.widget.separator
                    },
                    bottom_rows,
                    layout = wibox.layout.fixed.vertical
                },
                margins = 8,
                widget = wibox.container.margin
            }
        end)
    end)
end
local net_widget = {}
local function prepare_net_text(text)
    local net = string.gsub(text, "%s+", "")
    net = string.gsub(net, ",", ".")
    net = string.gsub(net, "bit/s", "B")

    local num = string.gsub(net, "[^%d.]", "")
    local si = string.gsub(net, "[%d.]", "")

    num = tonumber(num)
    if num >= 100 then
        num = math.floor(num)
    elseif num >= 10 then
        num = tonumber(string.format("%.1f", num))
    end

    return num .. si
end
local function worker(user_args)
    local args = user_args or {}
    local timeout = args.timeout or 2

    net_widget = wibox.widget {
        {
            id = 'icon',
            markup = ' ',
            font = 'Material Icons, 12',
            widget = wibox.widget.textbox
        },
        {
            id = 'net_in',
            markup = 'calculate',
            font = 'Droid Sans, Bold 9',
            widget = wibox.widget.textbox
        },
        {
            id = 'net_out',
            markup = '...',
            align = 'right',
            font = 'Droid Sans, Bold 9',
            widget = wibox.widget.textbox
        },
        forced_width = 120,
        layout = wibox.layout.fixed.horizontal
    }

    local cmd_internet_status = [[bash -c "ping -i 0.5 -c 5 1.1.1.1"]]
    watch(cmd_internet_status, 3, function(widget, stdout)
        local function get_internet_loss_package(stdout)
            for line in stdout:gmatch("[^\r\n]+") do
                if line:match("packets") then
                    for subline in line:gmatch("[^,]+") do
                        if subline:match("packet loss") then
                            subline = subline:gsub("%% packet loss", "")
                            local packet_loss = subline:gsub(" ", "")
                            return tonumber(packet_loss)
                        end
                    end
                end
            end
        end

        if stdout ~= "" then
            widget.icon.markup = '<span color="' ..
                                     fade_RGB("#FF0000", "#00FF00", 110 - get_internet_loss_package(stdout)) ..
                                     '"> </span>'
        end
    end, net_widget)

    local cmd_net_in_used = [[bash -c  "vnstat -tr | grep -w rx | awk '{print $2,$3}'"]]
    watch(cmd_net_in_used, timeout, function(widget, stdout)
        widget.net_in.markup = prepare_net_text(stdout)
    end, net_widget)

    local cmd_net_out_used = [[bash -c  "vnstat -tr | grep -w tx | awk '{print $2,$3}'"]]
    watch(cmd_net_out_used, timeout, function(widget, stdout)
        widget.net_out.markup = " " .. prepare_net_text(stdout)
    end, net_widget)

    popup_create(net_widget, timeout)
    return net_widget
end

return setmetatable(net_widget, {
    __call = function(_, ...)
        return worker(...)
    end
})
