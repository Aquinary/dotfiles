local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")

local datetime = wibox.widget {
  format = '%H:%M',
  font = 'Droid Sans, Bold 9',
  widget = wibox.widget.textclock,
}

local popup = awful.popup {
  ontop = true,
  visible = false,

  border_width = 1,
  border_color = beautiful.bg_normal,
  offset = { y = 4 },
  widget = {}
}


datetime:connect_signal("mouse::enter", function()

  popup.visible = true
  popup:move_next_to(mouse.current_widget_geometry)
  awful.spawn.easy_async([[bash -c "date | awk '{ print $1, $2, $3, $7}'"]], function(stdout, a)
    popup:setup {
      wibox.widget {
        id = 'date',
        text = stdout:gsub("\n", ""),
        widget = wibox.widget.textbox
      },
      margins = 8,
      widget = wibox.container.margin
    }
  end)
end)
datetime:connect_signal("mouse::leave", function()
  popup.visible = false
end)


return datetime
