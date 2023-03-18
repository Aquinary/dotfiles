local gears = require("gears")
local awful = require("awful")

tasklist_buttons = gears.table.join(
    -- ЛКМ
    awful.button({ }, 1, function(c)
        -- Сворачивать и разворачивать приложение
        if c.minimized == false then
            c.minimized = true
        else
            c:emit_signal(
                "request::activate",
                "tasklist",
                { raise = true }
            )
        end
    end),

    -- СКМ
    awful.button({ }, 2, function(c)
        -- По скм убиваем приложение
        c:kill()
    end),
    awful.button({ modkey }, 2, function(c)
        -- По mod4+скм убиваем приложение более грубым способом
        if c.pid then
            awful.spawn("killall -s 9 " .. c.instance)
        end
    end),

    -- ПКМ
    awful.button({ }, 3, function(c)

    end)
)

return taglist_buttons