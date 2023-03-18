local gears = require("gears")
local awful = require("awful")

  tags = {"", "", "", "", "", ""}
  -- Переключение тегов кнопкой мыши
  taglist_buttons = gears.table.join(
  awful.button({ }, 1, function(t) t:view_only() end)
)

  function require_tags(screen)
    awful.tag(tags, screen, awful.layout.layouts[2])
  end




