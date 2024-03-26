-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

awful.spawn.with_shell "~/.config/awesome/bin/autorun.sh"

local log = require("log")
local spawn = require("spawn")

local btn = {
    LEFT = 1,
    RIGHT = 3,
    SCROLL_UP = 4,
    SCROLL_DOWN = 5,
}

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify {
        preset = naughty.config.presets.critical,
        title = "Oops, there were errors during startup!",
        text = awesome.startup_errors
    }
    log.error("Startup errors %s", awesome.startup_errors)
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify {
            preset = naughty.config.presets.critical,
            title = "Uncaught error",
            text = require("log.stringify").stringify(err)
        }
        log.error("Uncaught error: %s", err)
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init(gears.filesystem.get_themes_dir() .. "zenburn/theme.lua")

beautiful.useless_gap = 10

local terminal = "alacritty"

local modkey = "Mod4"

awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.floating,
    awful.layout.suit.magnifier,
}
-- }}}

-- {{{ Menu
local power_menu = awful.menu({
    items = {
        { "power off", spawn "shutdown now" },
        { "restart", spawn "shutdown -r now" },
        { "logout", function() awesome.quit() end },
    },
})

local mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = power_menu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Wibar
-- Create a textclock widget
local mytextclock = wibox.widget.textclock()

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
                    awful.button({ }, btn.LEFT, function(t) t:view_only() end),
                    awful.button({ modkey }, btn.LEFT, function(t)
                                              if client.focus then
                                                  client.focus:move_to_tag(t)
                                              end
                                          end),
                    awful.button({ }, btn.RIGHT, awful.tag.viewtoggle),
                    awful.button({ modkey }, btn.RIGHT, function(t)
                                              if client.focus then
                                                  client.focus:toggle_tag(t)
                                              end
                                          end),
                    awful.button({ }, btn.SCROLL_UP, function(t) awful.tag.viewnext(t.screen) end),
                    awful.button({ }, btn.SCROLL_DOWN, function(t) awful.tag.viewprev(t.screen) end)
                )

local tasklist_buttons = gears.table.join(
                     awful.button({ }, btn.LEFT, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  c:emit_signal(
                                                      "request::activate",
                                                      "tasklist",
                                                      {raise = true}
                                                  )
                                              end
                                          end),
                     awful.button({ }, btn.SCROLL_UP, function ()
                                              awful.client.focus.byidx(1)
                                          end),
                     awful.button({ }, btn.SCROLL_DOWN, function ()
                                              awful.client.focus.byidx(-1)
                                          end))



local function set_wallpaper()
    awful.spawn("nitrogen --restore", false)
end

screen.connect_signal("property::geometry", set_wallpaper)

local memory_widget = awful.widget.watch([[sh -c "free -h | sed -Ee '/Mem/!d;s/(G|M)i/\\1/g;s/\\S*\\s*(\\S*)\\s*(\\S*).*/    Memory: \\2\\/\\1    /'"]], 1)

awful.screen.connect_for_each_screen(function(s)
    -- Each screen has its own tag table.
    awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

    -- Smaller gaps for browser tags
    s.tags[2].gap = 2
    s.tags[3].gap = 2

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, btn.LEFT, function () awful.layout.inc( 1) end),
                           awful.button({ }, btn.RIGHT, function () awful.layout.inc(-1) end),
                           awful.button({ }, btn.SCROLL_UP, function () awful.layout.inc( 1) end),
                           awful.button({ }, btn.SCROLL_DOWN, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons
    }

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons
    }

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            mylauncher,
            s.mytaglist,
            s.mypromptbox,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            wibox.widget.systray(),
            mytextclock,
            memory_widget,
            s.mylayoutbox,
        },
    }
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
))
-- }}}

local function swap_screen_clients(self, other)
    for _, own_tag in ipairs(self.tags) do
        local other_tag = awful.tag.find_by_name(other, own_tag.name)
        local self_clients = own_tag:clients()
        local other_clients

        if other_tag then
            other_clients = other_tag:clients()
        else
            log.info("Didn't find tag with name %s on screen of geometry %s, will put clients to first tag", own_tag.name, other.geometry)
            other_tag = other.tags[1]
            other_clients = {}
        end

        for _, c in ipairs(self_clients) do
            c:move_to_tag(other_tag)
        end

        for _, c in ipairs(other_clients) do
            c:move_to_tag(own_tag)
        end
    end
end

-- {{{ Key bindings
local globalkeys = gears.table.join(
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "b", awful.tag.history.restore,
              {description = "go back", group = "tag"}),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),

    -- Standard program
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),

    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                    c:emit_signal(
                        "request::activate", "key.unminimize", {raise = true}
                    )
                  end
              end,
              {description = "restore minimized", group = "client"}),

    awful.key({ modkey, "Shift" }, "x",
              function ()
                  awful.prompt.run {
                    prompt       = "Run Lua code: ",
                    textbox      = awful.screen.focused().mypromptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                  }
              end,
              {description = "lua execute prompt", group = "awesome"}),

    -- Screens
    awful.key({ modkey,           }, "o",      function () awful.screen.focus_relative(1)   end,
              {description = "switch screen focus", group = "client"}),
    awful.key({ modkey, "Shift"   }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),
    awful.key({ modkey, "Mod1"     }, "o",
        function ()
            if screen.count() > 1 then
                swap_screen_clients(screen[1], screen[2])
            end
        end,
        {description = "swap screens", group = "client"}),

    -- Launching
    awful.key({ modkey }, "p", function() menubar.show() end,
              {description = "show the menubar", group = "launcher"}),
    awful.key({ modkey },            "r",     function () awful.screen.focused().mypromptbox:run() end,
              {description = "run prompt", group = "launcher"}),
    awful.key({ modkey,           }, "Return", spawn(terminal),
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey,           }, "d", spawn.editor_at "~/.dotfiles",
              {description = "edit dotfiles", group = "launcher"}),
    awful.key({ modkey,           }, "y", spawn.term "yazi",
              {description = "yazi", group = "launcher"}),
    awful.key({ modkey,           }, "w", spawn.at_tag("firefox", 2),
              {description = "firefox", group = "launcher"}),
    awful.key({ modkey, "Shift"   }, "w", spawn.at_tag("firefox --private-window", 3),
              {description = "firefox private window", group = "launcher"}),
    awful.key({ modkey, "Shift"   }, "s", spawn.with_shell "~/.config/awesome/bin/screenshot.sh",
              {description = "screenshot", group = "launcher"}),
    awful.key({ modkey            }, "x", function () power_menu:show() end,
              {description = "power menu", group = "launcher"}),
    awful.key({ modkey,           }, "Escape", spawn("xkill"),
              {description = "go back", group = "tag"}),


    -- Screen brightness
    awful.key({ }, "XF86MonBrightnessUp", spawn("xbacklight -inc 10"),
              {description = "brightness up", group = "hotkeys"}),
    awful.key({ }, "XF86MonBrightnessDown", spawn("xbacklight -dec 10"),
              {description = "brightness down", group = "hotkeys"}),
    -- Media keys
    awful.key({ }, "XF86AudioPlay", spawn("mpc toggle"),
              {description = "media play", group = "hotkeys"}),
    awful.key({ }, "XF86AudioPrev", spawn("mpc prev"),
              {description = "media prev", group = "hotkeys"}),
    awful.key({ }, "XF86AudioNext", spawn("mpc next"),
              {description = "media next", group = "hotkeys"}),
    awful.key({ }, "XF86AudioStop", spawn("mpc stop"),
              {description = "media stop", group = "hotkeys"}),
    awful.key({ }, "XF86AudioRaiseVolume", spawn("amixer -Mq set Master,0 5%+ unmute"),
              {description = "volume up", group = "hotkeys"}),
    awful.key({ }, "XF86AudioLowerVolume", spawn("amixer -Mq set Master,0 5%- unmute"),
              {description = "volume down", group = "hotkeys"}),
    awful.key({ }, "XF86AudioMute", spawn("amixer set Master toggle"),
              {description = "mute", group = "hotkeys"})

)

local clientkeys = gears.table.join(
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey,           }, "c",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "(un)maximize", group = "client"}),
    awful.key({ modkey, "Control" }, "m",
        function (c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end ,
        {description = "(un)maximize vertically", group = "client"}),
    awful.key({ modkey, "Shift"   }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end ,
        {description = "(un)maximize horizontally", group = "client"})
)

for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

local clientbuttons = gears.table.join(
    awful.button({ }, btn.LEFT, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, btn.LEFT, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        c.floating = true
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, btn.RIGHT, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        c.floating = true
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    {
        rule = { },
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap+awful.placement.no_offscreen
        }
    },

    -- Floating clients.
    {
        rule_any = {
            instance = {
                "DTA",  -- Firefox addon DownThemAll.
                "copyq",  -- Includes session name in class.
                "pinentry",
            },
            class = {
                "Arandr",
                "Blueman-manager",
                "Gpick",
                "Kruler",
                "MessageWin",  -- kalarm.
                "Sxiv",
                "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
                "Wpa_gui",
                "veromix",
                "xtightvncviewer",
                "VirtualBox Manager",
            },

            -- Note that the name property shown in xprop might be set slightly after creation of the client
            -- and the name shown there might not match defined rules here.
            name = {
                "Event Tester",  -- xev.
            },
            role = {
                "AlarmWindow",  -- Thunderbird's calendar.
                "ConfigManager",  -- Thunderbird's about:config.
                "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
            }
        },
        properties = { floating = true }
    },

    -- Add titlebars to normal clients and dialogs
    {
        rule_any = { type = { "normal", "dialog" } },
        properties = { titlebars_enabled = false }
    },

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
    c.shape = gears.shape.rounded_rect
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, btn.LEFT, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, btn.RIGHT, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Titlebar on floating windows
client.connect_signal("property::floating", function(c)
    if c.floating and
        not c.requests_no_titlebar and
        not c.fullscreen and
        not c.maximized and
        not c.maximized_vertical
    then
        awful.titlebar.show(c)
    else
        awful.titlebar.hide(c)
    end
end)

client.connect_signal("focus", function(c) c.border_color = "#84717f" end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

client.connect_signal("property::urgent", function(c)
    log.debug("urgent called for %s %s", c.class, c.name)
    if c.class ==  "Alacritty" then return end
    c.minimized = false
    c:jump_to()
end)
-- }}}

