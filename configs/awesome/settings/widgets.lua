widgets = {}

function require_widgets(s)
    local awful = require("awful")
    local wibox = require("wibox")
    local gears = require("gears")
    local beautiful = require("beautiful")


    --[[ Виджет разделения других виджетов ]] --
    widgets.separator = wibox.widget {
        orientation = 'vertical',
        forced_height = 10,
        forced_width = 10,
        thickness = 0,
        widget = wibox.widget.separator,
    }

    widgets.monitor = require('widgets.monitor')

    --[[ Виджет списка тегов ]] --
    widgets.taglist = awful.widget.taglist {
        screen          = s,
        filter          = awful.widget.taglist.filter.all,
        style           = {
            bg_normal = "#000000",
            bg_focus = "#212529",
            fg_minimize = "#111111" .. "50",
            bg_minimize = "#000000",
            bg_urgent = "#FBE698" .. "30",
        },
        layout          = {
            spacing = 0,
            layout  = wibox.layout.fixed.horizontal
        },
        buttons         = taglist_buttons,
        widget_template = {
            {
                {
                    {
                        id = 'text_role',
                        widget = wibox.widget.textbox,
                    },
                    layout = wibox.layout.flex.horizontal,
                },
                top = 2,
                left = 7,
                right = 7,
                widget = wibox.container.margin
            },
            id = 'background_role',
            widget = wibox.container.background,
        },
    }

    --[[ Виджет списка запущенных приложений на текущем теге --]]
    widgets.tasklist = wibox.widget {
        {
            widget = awful.widget.tasklist {
                screen = s,
                filter  = awful.widget.tasklist.filter.currenttags,
                buttons = tasklist_buttons,
                style = {
                    bg_normal = "#000000",
                    bg_focus = "#212529",
                    fg_minimize = "#FFFFFF" .. "60",
                    bg_minimize = "#000000",
                    bg_urgent = "#FBE698" .. "30",

                },

                widget_template =
                {
                    {
                        {
                            {
                                {
                                    id     = 'icon_role',
                                    widget = wibox.widget.imagebox,
                                },
                                right = 6,
                                widget  = wibox.container.margin,
                            },
                            {
                                id     = 'text_role',
                                widget = wibox.widget.textbox,
                            },

                            layout = wibox.layout.fixed.horizontal,

                        },
                        left = 7,
                        right = 6,
                        top = 6,
                        bottom = 6,
                        widget = wibox.container.margin
                    },

                    id     = 'background_role',
                    forced_width = 180,
                    widget = wibox.container.background,
                },
            },
        },
        widget = wibox.container.place
    }    --[[ Текущее время --]]
    widgets.datetime = require('widgets.datetime')

    -- Индикатор стиля отображения рабочего стола
    local layoutbox = awful.widget.layoutbox(s)

    -- Переключение стиля кликом по иконке
    layoutbox:buttons(gears.table.join
        (
            awful.button({}, 1, function() awful.layout.inc(1) end),
            awful.button({}, 3, function() awful.layout.inc(-1) end),
            awful.button({}, 4, function() awful.layout.inc(1) end),
            awful.button({}, 5, function() awful.layout.inc(-1) end))
    )

    -- Центрируем по середине и делаем отступ вверх
    widgets.layoutbox = wibox.container.margin(layoutbox, 3, 6, 6, 7)

    -- awful.widget.keyboardlayout,
    widgets.keyboard = wibox.widget {
        {
            {
                widget = awful.widget.keyboardlayout(),
            },
            widget = wibox.container.margin,
            bottom = 2,

        },
        widget = wibox.container.place
    }

    widgets.keyboard.widget.widget.font = "Franklin Gothic Medium, 11"

    -- Системный трей
    -- без этого на втором мониторе заметен слишком большой пробел между часами и индикатором языковой раскладки
    if screen[1] == s then
        widgets.systray = wibox.widget {
            {
                wibox.widget.systray(),
                left   = 0,
                top    = 8,
                bottom = 8,
                right  = 10,
                widget = wibox.container.margin,
            },
            shape      = gears.shape.rounded_rect,
            widget     = wibox.container.background,
        }
    else 
        widgets.systray = nil
    end
    return widgets
end
