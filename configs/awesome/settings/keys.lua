local gears = require("gears")
local awful = require("awful")
local menubar = require("menubar")

modkey = 'Mod4'

event = {
    root = {},
    client = {}
}

--[[ Сочетания клавиш, которые работают только в области клиента ]] --
event.client.keys = gears.table.join(
    awful.key({ modkey }, "q", function(c) c:kill() end, { description = "Завершить приложение" }),
    awful.key({ modkey }, "f", function(c) c.fullscreen = not c.fullscreen end, { description = "Переключить полноэкранный режим" }),
    awful.key({ modkey }, "m", function(c) c.maximized = not c.maximized c:raise() end, { description = "Переключить максимизируемый режим режим" }),
    awful.key({ modkey }, "d", function(c)
        pprint("Instance: " .. tostring(c.instance))
        pprint("Class: " .. tostring(c.class))
        pprint("Name: " .. tostring(c.name))
        pprint("Type: " .. tostring(c.type))
    end, { description = 'Вывод информации о клиенте' }),
    awful.key({ modkey, "Control" }, "space", awful.client.floating.toggle, { description = "Переключить плавающий режим" })
)

-- [[ Перемещение клиента на другой тег ]] --
for i = 1, 9 do
    event.client.keys = gears.table.join(
        event.client.keys,
        awful.key({ modkey }, "#" .. i + 9, function(c)
            if client.focus then
                local tag = client.focus.screen.tags[i]
                if tag then
                    if next(awful.rules.rules) ~= nil then
                        global_rules = awful.rules.rules
                    end

                    awful.rules.rules = {}
                    client.focus:move_to_tag(tag)
                    awful.rules.apply(c)
                end
            end
        end)
    )
end


--[[ Взаимодействие мыши с клиентом ]] --
event.client.buttons = gears.table.join(event.client.buttons,
    awful.button({}, 1, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
    end, { description = "Активация фокуса выбранного клиента" }),

    awful.button({ modkey }, 1, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
        local this_screen = c.screen

        if next(global_rules) ~= nil then
            awful.rules.rules = global_rules
        end

        awful.mouse.client.move(c)
        -- если клиент переносится в рамках одного монитора, то его позиция в теге сохроняется
        -- при перемещнии на другой монитор для клиента применяются стандартные правила
        if (c.screen ~= this_screen) then
            awful.rules.apply(c)
        end
    end, { description = "Перемещение клиента" }),

    awful.button({ modkey }, 3, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
        awful.mouse.client.resize(c)
    end, { description = "Изменение размера клиента" }),

    awful.button({ modkey }, 5, function(t)
        awful.tag.viewnext(t.screen)
    end),

    awful.button({ modkey }, 4, function(t)
        awful.tag.viewprev(t.screen)
    end)
)


local hotkeys_popup = require("awful.hotkeys_popup")

require("awful.hotkeys_popup.keys")
--[[ Глобальные сочетания клавиш в ВМ ]] --
event.root.keys = gears.table.join(
    awful.key({ modkey }, "Left", awful.tag.viewprev, {description = 'Предыдущий тег'}),
    awful.key({ modkey }, "Right", awful.tag.viewnext, {description = 'Следующий тег'}),
    awful.key({ modkey }, "Return", function() awful.spawn(terminal) end, {description = 'Запуск терминала'}),
    awful.key({ modkey, "Control" }, "r", awesome.restart, {description = 'Перезапуск AwesomeWM'}),
    awful.key({ modkey, }, "r", function()
        local screen_windows = {}
        -- пройтись по всем клиентам
        for _, c in ipairs(client.get()) do
            -- нужно для того, чтобы запомнить расположение на мониторах. Иначе всё скидывает на один монитор
            table.insert(screen_windows, {c, c.screen})

            if next(global_rules) ~= nil then
                awful.rules.rules = global_rules
            end
            awful.rules.apply(c)
        end

        -- восстанавливаем клиенты по мониторам
        for _, s in ipairs(screen_windows) do
            s[1]:move_to_screen(s[2])
        end

     end, {description = 'Применить правила для клиентов и вернуть их на свои места'}),
    awful.key({ modkey }, "space", function() awful.layout.inc(1) end, {description = 'Смена режима тайлинга'}),
    awful.key({}, "Menu", function() awful.spawn.with_shell('~/.config/awesome/widgets/rofi/menu.sh') end, {description = 'Запуск меню Rofi'}),
    awful.key({ modkey }, "Tab", function() awful.spawn.with_shell('~/.config/awesome/widgets/rofi/windows.sh') end, {description = 'Просмотр открытых окон'}),
    awful.key({}, "Pause", function() awful.spawn.with_shell('~/.config/awesome/widgets/rofi/powermenu.sh') end, {description = 'Запуск меню выключения'}),
    awful.key({}, "Print", function() os.execute('deepin-screenshot -f -n') end, {description = 'Скриншот всей рабочей области'}),
    awful.key({ modkey }, "v", function() os.execute('copyq toggle') end, {description = 'Меню буффера обмена'}),
    awful.key({ modkey }, "Print", function() os.execute('deepin-screenshot -n') end, {description = 'Скриншот выделенной области'}),
    awful.key({ modkey }, "`", function()
        awful.spawn.with_shell('tdrop -am -w 50% -h 50% -y 27% -x 26% sakura')
    end, {description = 'Скриншот выделенной области'}),
    awful.key({ modkey }, "h", function()
        hotkeys_popup.show_help(nil, awful.screen.focused())
    end, {description = 'Вывод текущего окна'}),
    awful.key({ modkey }, 1, function (t)
        pprint(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end
    end)
)

--[[ Глобальное взаимодействие мыши с ВМ ]] --
event.root.buttons = gears.table.join(
-- Переключение на предыдущий/следующий тег
    awful.button({ modkey }, 4, awful.tag.viewprev),
    awful.button({ modkey }, 5, awful.tag.viewnext),
    awful.button({ modkey }, 1, function (t)
        pprint(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end
    end)
)

root.keys(event.root.keys)
root.buttons(event.root.buttons)
