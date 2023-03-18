-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.

pcall(require, "luarocks.loader")

local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")

require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")

require('settings.utils')

require('settings.keys')
require('settings.tasks')
require('settings.tags')
require('settings.widgets')
require('settings.panel')


require("awful.autofocus")

os.setlocale(os.getenv("LANG"))
-- Общие темы для WM
beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")
beautiful.useless_gap = 3
beautiful.gap_single_client = true
beautiful.font = "FranklinGothicMedium 10"
beautiful.taglist_font = "icons-in-terminal 13"
beautiful.border_focus = "#1398ec"
beautiful.border_width = 1
beautiful.bg_systray = "#000000"
beautiful.systray_icon_spacing = 4
beautiful.hotkeys_font = "FranklinGothicMedium 10"
beautiful.hotkeys_description_font = "FranklinGothicMedium 10"

-- Терминал и редактор по умолчаниюdsdsdsвыв
terminal = "sakura"
editor = os.getenv("EDITOR") or "subl"
editor_cmd = terminal .. " -e " .. editor
home_dir = os.getenv('HOME')

-- Какие режимы для рабочего стола доступны
awful.layout.layouts = {
    awful.layout.suit.floating,
    awful.layout.suit.tile,
}

awful.screen.connect_for_each_screen(function(s)
    require_tags(s)
    require_widgets(s)
    require_panel(s)
end)


require('settings.rules')
client.connect_signal("tagged", function(c)
    -- При перемещии приложения на другой монитор переносит его в нужный тег
    awful.rules.apply(c)
    -- После запуска приложения переходит на тот же тег, где находится и само приложение
    c.first_tag:view_only()
end)

-- Сигналы для событий
client.connect_signal("manage", function (c)
    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        awful.placement.no_offscreen(c)
    end

    --[[
        Фикс для некоторых приложений (привет, спотифай!), который перемещает приложения в нужный тег
        Без этого правила на эти приложения (ПРИВЕТ, СПОТИФАЙ!!!), работать адекватно не будут
    ]]--
    if c.class == nil then
        c:connect_signal("property::instance", function ()
            awful.rules.apply(c)
        end)
    end
    
    -- После запуска приложения переходит на тот же тег, где находится и само приложение
    c.first_tag:view_only()
end)


client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)
client.connect_signal("mouse::move", function(c)
   c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

-- Окна, которые находятся в фокусе, обводятся рамкой
client.connect_signal("focus", function(c)
    c.border_color = beautiful.border_focus
end)
client.connect_signal("unfocus", function(c)
    c.border_color = beautiful.border_normal
end)


awful.spawn.with_shell(GET_FILE_PATH() .. 'autorun.sh')

