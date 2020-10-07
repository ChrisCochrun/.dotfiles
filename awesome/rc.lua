pcall(require, "luarocks.loader")
-- local fennel = require("./fennel")
fennel = require("fennel")
local gears = require("gears")
fennel.path = fennel.path .. ";.config/awesome/?.fnl"
table.insert(package.loaders or package.searchers, fennel.make_searcher({correlate=true}))
-- table.insert(package.loaders or package.searchers, fennel.searcher)
require("init") -- loads init.fnl



-- Standard awesome library
local awful = require("awful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
-- local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
local ruled = require("ruled")
-- local ruls = require("configuration.client.rules")

-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- Modules
require('module.notifications')
require('module.backdrop')
require('module.volume-osd')
require('module.brightness-osd')

-- {{{ Variable definitions
beautiful.init("/home/chris/.config/awesome/theme.lua")
terminal = "alacritty"
editor = "emacsclient -a emacs"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
modkey = "Mod4"
altkey = "Mod1"

awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.magnifier,
    awful.layout.suit.floating,
    -- awful.layout.suit.tile.left,
    -- awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    -- awful.layout.suit.fair.horizontal,
    -- awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    -- awful.layout.suit.max.fullscreen,
    -- awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}

-- Menu
myawesomemenu = {
   { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end },
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- Wibar
mytextclock = wibox.widget.textclock(" %a %b %d, %l:%M %p ")

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
                    awful.button({ }, 1, function(t) t:view_only() end),
                    awful.button({ modkey }, 1, function(t)
                                              if client.focus then
                                                  client.focus:move_to_tag(t)
                                              end
                                          end),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, function(t)
                                              if client.focus then
                                                  client.focus:toggle_tag(t)
                                              end
                                          end),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
                )

local tasklist_buttons = gears.table.join(
                     awful.button({ }, 1, function (c)
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
                     awful.button({ }, 3, function()
                                              awful.menu.client_list({ theme = { width = 250 } })
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                          end))

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)


-- awful.screen.connect_for_each_screen(function(s)
--      -- Wallpaper
--      set_wallpaper(s)

--      -- Each screen has its own tag table.
--      awful.tag({ "   ", "   ", "   ", "   "}, s, awful.layout.layouts[1])

--      s.padding = {
--          bottom = dpi(20)
--      }

--      yoffset = dpi(45)
--      xoffset = dpi(18)

--      mypanel = wibox
--      ({
--          x = s.geometry.x + xoffset,
--          y = s.geometry.height - yoffset,
--          height = dpi(30),
--          width = s.geometry.width - (xoffset * 2),
--          ontop = false,
--          stretch = false,
--          type = "dock",
--          screen = s,
--          shape = gears.shape.rounded_bar,
--          bg = beautiful.bg_normal,
--          fg = beautiful.fg_normal,
--          opacity = 0.65,
--      })

--      mypanel:struts {
--          bottom = dpi(40)
--      }

--      -- Create a promptbox for each screen
--      s.mypromptbox = awful.widget.prompt()
--      -- Create an imagebox widget which will contain an icon indicating which layout we're using.
--      -- We need one layoutbox per screen.
--      s.mylayoutbox = awful.widget.layoutbox(s)
--      s.mylayoutbox:buttons(gears.table.join(
--                             awful.button({ }, 1, function () awful.layout.inc( 1) end),
--                             awful.button({ }, 3, function () awful.layout.inc(-1) end),
--                             awful.button({ }, 4, function () awful.layout.inc( 1) end),
--                             awful.button({ }, 5, function () awful.layout.inc(-1) end)))
--      -- Create a taglist widget
--      s.mytaglist = awful.widget.taglist {
--          screen  = s,
--          filter  = awful.widget.taglist.filter.all,
--          buttons = taglist_buttons
--      }

--      -- Create a systray widget
--      s.mysystray = {
--          wibox.widget.systray(),
--          -- bg = "#00FF0066",
--          widget = wibox.container.background,
--      }

--      s.mytasklist = awful.widget.tasklist {
--          screen   = s,
--          filter   = awful.widget.tasklist.filter.currenttags,
--          buttons  = tasklist_buttons,
--          style    = {
--              border_width = 0,
--              border_color = '#777777',
--              shape        = gears.shape.rounded_bar,

--          },
--          layout   = {
--              spacing = 20,
--              spacing_widget = {
--                  {
--                      forced_width = 5,
--                      forced_height = dpi(20),
--                      -- shape        = gears.shape.circle,
--                      widget       = wibox.widget.separator
--                  },
--                  valign = 'center',
--                  halign = 'center',
--                  widget = wibox.container.place,
--              },
--              layout  = wibox.layout.flex.horizontal
--          },
--          -- notice that there is *no* wibox.wibox prefix, it is a template,
--          -- not a widget instance.
--          widget_template = {
--              {
--                  {
--                      {
--                          {
--                              id     = 'icon_role',
--                              widget = wibox.widget.imagebox,
--                          },
--                          margins = 2,
--                          widget  = wibox.container.margin,
--                      },
--                      {
--                          id     = 'text_role',
--                          widget = wibox.widget.textbox,
--                      },
--                      layout = wibox.layout.align.horizontal,
--                  },
--                  left  = 10,
--                  right = 10,
--                  widget = wibox.container.margin
--              },
--              id     = 'background_role',
--              widget = wibox.container.background,
--          },
--      }
--      -- Create Battery, Network, and Volume widget
--      s.battery = require('widget.battery')()
--      -- s.network = require('widget.network')()
--      s.volume = require('widget.volume')()
--      s.updater = require('widget.package-updater')()

--      s.myrightwidgets =
--          {
--              { -- Right widgets
--                  layout = wibox.layout.fixed.horizontal,
--                  s.volume,
--                  s.mysystray,
--                  s.updater,
--                  -- s.network,
--                  s.battery,
--                  wibox.container.margin (s.mylayoutbox,0,dpi(25),0,0),
--              },
--              -- bg = "#00FF0066",
--              widget = wibox.container.background,
--          }

--      -- Empty widget to use for spacing
--      s.myemptywidget = wibox.widget{
--          markup = '',
--          align = '',
--          valign = '',
--          widget = wibox.widget.textbox
--      }

-- --     -- Add widgets to the wibox
--      mypanel:setup {
--          layout = wibox.layout.align.horizontal,
--          expand = "outside",
--          { -- Left widgets
--              layout = wibox.layout.align.horizontal,
--              wibox.container.margin (s.mytaglist,dpi(15),0,dpi(-3),0),
--              wibox.container.margin (s.mytasklist,dpi(25),dpi(25),0,0), -- Middle widget
--              s.myemptywidget,
--              spacing = dpi(15)
--          },
--              mytextclock,
--          { -- Right widgets
--              layout = wibox.layout.align.horizontal,
--              s.myemptywidget,
--              wibox.container.margin (s.mypromptbox,dpi(25),dpi(25),0,0), -- Middle widget
--              s.myrightwidgets,
--          },
--          visible = true,
--      }

--      mypanel.visible = true
--  end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
awful.keyboard.append_global_keybindings({
    awful.key({ modkey,           }, "s",      hotkeys_popup.keys,
              {description="show help", group="awesome"}),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
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
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end,
              {description = "show main menu", group = "awesome"}),

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


    -- Screenshots
    awful.key({}, "Print", function() awful.util.spawn("flameshot gui")    end,
       {description = "take a screenshot", group = "screen"}),

    -- Increase-Decrease Gap

    awful.key({ modkey, altkey }, "k", function () awful.tag.incgap (  1, null)    end,
      {description = "increase gap", group = "layout"}),

    awful.key({ modkey, altkey }, "j", function () awful.tag.incgap ( -1, null)    end,
      {description = "decrease gap", group = "layout"}),


    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),

    -- Programs
    awful.key({ modkey,           }, "b", function () awful.spawn("firefox") end,
              {description = "open firefox", group = "apps"}),
    awful.key({ modkey,           }, "e", function () awful.spawn("emacsclient -c") end,
              {description = "open emacs frame connected to server", group = "apps"}),
    -- dolphin
    awful.key({ modkey,           }, "d", function () awful.spawn("dolphin") end,
              {description = "open dolphin file manager", group = "apps"}),
    -- layout
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

   -- Volume Keys
   awful.key({}, "XF86AudioLowerVolume", function ()
     awful.util.spawn("amixer -D pulse sset Master 5%-", false)
     awful.util.spawn("mpv /home/chris/Music/notifications/Pop-709f8e26-a350-3999-9e86-aa91b8602650.mp3")
     awesome.emit_signal('widget::volume')
     awesome.emit_signal('module::volume_osd:show', true)
   end),
   awful.key({}, "XF86AudioRaiseVolume", function ()
     awful.util.spawn("amixer -D pulse sset Master 5%+", false)
     awful.util.spawn("mpv /home/chris/Music/notifications/Pop-16da230f-5ffc-4a42-93df-a169e9253ddc.mp3")
     awesome.emit_signal('widget::volume')
     awesome.emit_signal('module::volume_osd:show', true)
   end),
   awful.key({}, "XF86AudioMute", function ()
     awful.util.spawn("amixer set Master 1+ toggle", false)
   end),
   -- Media Keys
   awful.key({}, "XF86AudioPlay", function()
     awful.util.spawn("playerctl play-pause", false)
   end),
   awful.key({}, "XF86AudioNext", function()
     awful.util.spawn("playerctl next", false)
   end),
   awful.key({}, "XF86AudioPrev", function()
     awful.util.spawn("playerctl previous", false)
   end),
       -- Mute Microphone
   awful.key({}, "XF86Launch8", function()
     awful.util.spawn("amixer -c 2 set Mic toggle", false)
   end),

   awful.key({}, "XF86Launch7", function()
     awful.util.spawn("", false)
   end),
   awful.key({}, "XF86Launch6", function()
     awful.util.spawn("", false)
   end),
   awful.key({}, "XF86Launch5", function()
     awful.util.spawn("", false)
   end),
   awful.key({}, "XF86Tools", function()
     awful.util.spawn("", false)
   end),
    -- Brightness Keys
   awful.key({}, "XF86MonBrightnessUp", function()
           awful.util.spawn("brightnessctl set +10%", false)
           awesome.emit_signal('widget::brightness')
           awesome.emit_signal('module::brightness_osd:show', true)
   end),

   awful.key({}, "XF86MonBrightnessDown", function()
           awful.util.spawn("brightnessctl set 10%-", false)
           awesome.emit_signal('widget::brightness')
           awesome.emit_signal('module::brightness_osd:show', true)
   end),

    -- Prompt
    awful.key({ },   "Menu",     function ()
        awful.util.spawn("/home/chris/.dotfiles/rofi/launchers-git/launcher.sh") end,
              {description = "launch rofi", group = "launcher"}),

    -- Window Switcher
    awful.key({ modkey },   "Tab",     function ()
        awful.util.spawn("/home/chris/.dotfiles/rofi/launchers-git/windows.sh") end,
              {description = "launch rofi window switcher", group = "launcher"}),

    -- Emoji Selector
    awful.key({ modkey },   ".",     function ()
        awful.util.spawn("/home/chris/.dotfiles/rofi/launchers-git/emoji.sh") end,
              {description = "launch rofi emoji picker", group = "launcher"}),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run {
                    prompt       = "Run Lua code: ",
                    textbox      = awful.screen.focused().mypromptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                  }
              end,
              {description = "lua execute prompt", group = "awesome"}),
    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end,
              {description = "show the menubar", group = "launcher"})
})

client.connect_signal("request::default_keybindings", function()
    awful.keyboard.append_client_keybindings({
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey, }, "c",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),
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
    })
end)


-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
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

awful.mouse.append_global_mousebindings({
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewprev),
    awful.button({ }, 5, awful.tag.viewnext),
})

client.connect_signal("request::default_mousebindings", function()
    awful.mouse.append_client_mousebindings({
        awful.button({ }, 1, function (c)
            c:activate { context = "mouse_click" }
        end),
        awful.button({ modkey }, 1, function (c)
            c:activate { context = "mouse_click", action = "mouse_move"  }
        end),
        awful.button({ modkey }, 3, function (c)
            c:activate { context = "mouse_click", action = "mouse_resize"}
        end),
    })
end)

-- Set keys
root.keys(globalkeys)
-- }}}



-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end

    ruled.client.apply(c)
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
