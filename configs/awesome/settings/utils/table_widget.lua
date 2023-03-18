local awful = require("awful")
local awful_old = require('awful')
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")



-- [[ Создаёт таблицу внутри виджета ]] --
function table_widget_create(args)
  local function create_textbox(arguments)
      arguments.markup = arguments.text
      if arguments.is_bold then
          arguments.markup = '<b>' .. arguments.text .. '</b>'
      end
      return wibox.widget {
          markup = arguments.markup,
          align = arguments.align or 'left',
          font = 'Droid Sans 9',
          forced_width = arguments.forced_width or 90,
          forced_height = arguments.forced_height or 20,
          widget = wibox.widget.textbox
      }
  end

  local rows = args['rows']
  local is_bold = args['is_bold'] or false
  local wdg = {}

  local first_column = rows[1]
  local other_colums = {
      layout = wibox.layout.fixed.horizontal
  }

  for k, v in pairs(rows) do
      if v ~= first_column then
          other_colums[k] = create_textbox {
              text = v,
              align = 'center',
              is_bold = is_bold
          }
      end
  end

  wdg = wibox.widget {
      create_textbox {
          text = first_column,
          is_bold = is_bold
      },
      other_colums,
      layout = wibox.layout.fixed.horizontal
  }


  local row = wibox.widget {
      {
          wdg,
          top = 4,
          bottom = 4,
          left = 4,
          widget = wibox.container.margin
      },
      widget = wibox.container.background
  }
  return row
end

