-- awesome lib
local g = require("gears")
local a = require("awful")
local w = require("wibox")
local b = require("beautiful")
require("awful.autofocus")

-- theme
b.init("~/.config/awesome/default/theme.lua")
-- alt-key
modkey = "Mod1"

-- Layouts 
a.layout.layouts = {
    a.layout.suit.spiral,
    a.layout.suit.floating,
    a.layout.suit.max.fullscreen,
}

a.screen.connect_for_each_screen(function(s)

    -- Each screen has its own tag table.
    a.tag({ "001", "002", "003", "004", "005", "006", "007", "008", "009" }, s, a.layout.layouts[1])

    -- Create a taglist widget
    s.mytaglist = a.widget.taglist {
        screen  = s,
        filter  = a.widget.taglist.filter.all,
        buttons = taglist_buttons
    }

    -- Create the wibox
    s.wbx = a.wibar({ position = "top", screen = s })
    -- Add widgets to the wibox
    -- example
    ex = a.widget.watch('tt -o', 0.5)
    s.wbx:setup {
        layout = w.layout.align.horizontal,
        { -- Left widgets
            layout = w.layout.fixed.horizontal,
            s.mytaglist,
        },
        { -- Right widgets
            layout = w.layout.fixed.horizontal,
            ex
        },
    }
end)

-- {{{ Key bindings
globalkeys = g.table.join(
    a.key({ modkey,           }, "j",
        function ()
            a.client.focus.byidx( 1)
        end
    ),
    a.key({ modkey,           }, "k",
        function ()
            a.client.focus.byidx(-1)
        end
    ),

    -- Standard program
    a.key({ modkey }, "a",      function () a.spawn("alacritty") end),
    a.key({ modkey }, "r",                           awesome.restart),
    a.key({ modkey }, "q",                              awesome.quit),
    a.key({ modkey }, "space", function () a.layout.inc( 1)      end),
    a.key({ modkey }, "p", function()       a.spawn("dmenu_run") end)
)

clientkeys = g.table.join(
    a.key({ modkey }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end),
    a.key({ modkey }, "d", function (c) c:kill() end)
)

-- Bind all key numbers to tags.
for i = 1, 9 do
    globalkeys = g.table.join(globalkeys,
        -- View tag only.
        a.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = a.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end),
        -- Move client to tag.
        a.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end)
    )
end

clientbuttons = g.table.join(
    a.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    a.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        a.mouse.client.move(c)
    end),
    a.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        a.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)

-- Rules to apply to new clients
a.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = b.border_width,
                     border_color = b.border_normal,
                     focus = a.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = a.screen.preferred,
                     placement = a.placement.no_overlap+a.placement.no_offscreen
     }
    },
}

client.connect_signal("focus", function(c) c.border_color = b.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = b.border_normal end)
