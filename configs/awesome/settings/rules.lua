local awful = require("awful")
local beautiful = require("beautiful")


-- с помощью этого добиаваеся функционала, при котором можно перемещать клиентские окна на теги против правил
global_rules = {}
awful.rules.rules = {
    -- All clients will match this rule.
    {
        rule = { },
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = event.client.keys,
            buttons = event.client.buttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap+awful.placement.no_offscreen
        }
    },
    {
        -- диалоговые окна выравниваем по центру
        rule_any = { type = {"dialog"} },
        properties = {
            placement = awful.placement.centered
        }
    },
    {
        rule_any = { instance = {"caja"} },
        properties = {
            tag = ""
        }
    },
    {
        rule_any = { instance = {"vivaldi", "chromium", "discord", "zoho mail - desktop", "telegram-desktop"} },
        properties = {
            tag = ""
        }
    },
    {
        rule_any = { instance = {"jetbrains-webstorm", "jetbrains-pycharm", "code", "jetbrains-idea"} },
        properties = {
            tag = ""
        }
    },
    {
        rule_any = { instance = {"spotify", "shotwell", "figma"}},
        properties = {
            tag = ""
        }
    },
    -- 
    {
        rule = { class = "Steam"  },
        properties = {
            tag = ""
        }
    },
    {
        rule = { instance = "minecraft"  },
        properties = {
            tag = ""
        }
    },
    {
        rule = { instance = "tlauncher"  },
        properties = {
            tag = ""
        }
    },
    {
        rule = { class = "Mindustry"  },
        properties = {
            tag = ""
        }
    },
    -- 
    {
        rule_any = { instance = {"bitwarden", "fsearch", "notion", "virt-manager", "kfind"}  },
        properties = {
            tag = ""
        }
    },
    -- Другое
    {
        -- Исключаем картинку-в-картинке из тайлинга
        rule_any = { name = {"Picture in picture", "Картинка в картинке"} },
        properties = {
           floating = true,
           skip_taskbar = true,
        }
    },
    {
        -- Менеджер буффера по центру
        rule_any = { instance = {"copyq", "zenity"} },
        properties = {
           floating = true,
           callback = function (c)
              awful.placement.centered(c, nil)
           end
        }
    },
    {
        -- Переводчик
        rule = { instance = "crow" },
        properties = {
           floating = true,
            callback = function (c)
                awful.placement.under_mouse(c, nil)
            end
        }
    },
}


-- Spotify - особенный, без этого правила на него не сработают
--[[
client.connect_signal("manage", function (c)
  if c.class == nil then
    c:connect_signal("property::class", function ()
      c.minimized = false
    end)
  end
end)
--]]
