local themes_path = require("gears.filesystem").get_themes_dir()
local dpi = require("beautiful.xresources").apply_dpi

local t = {}

t.font          = "Hack 12"

t.fg_normal  = "#ECEFF4"
t.fg_focus   = "#88C0D0"
t.fg_urgent  = "#D08770"
t.bg_normal  = "#2E3440"
t.bg_focus   = "#3B4252"
t.bg_urgent  = "#3B4252"
t.bg_systray = t.bg_normal

t.useless_gap   = dpi(5.0)
t.border_width  = dpi(1.5)
t.border_normal = "#3B4252"
t.border_focus  = "#4C566A"
t.border_marked = "#D08770"

return t
