local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local watch = require("awful.widget.watch")
local wibox = require("wibox")

local ram_widget = require("widgets.monitor.ram")
local cpu_widget = require("widgets.monitor.cpu")
local hdd_widget = require("widgets.monitor.hdd")
local net_widget = require("widgets.monitor.net")


return {ram_widget(), hdd_widget(), cpu_widget(), net_widget()}