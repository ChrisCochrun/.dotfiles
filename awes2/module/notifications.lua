local gears = require('gears')
local wibox = require('wibox')
local awful = require('awful')
local ruled = require('ruled')
local naughty = require('naughty')
local menubar = require("menubar")
local beautiful = require('beautiful')

local dpi = beautiful.xresources.apply_dpi

local clickable_container = require('widget.clickable-container')

-- Defaults
naughty.config.defaults.ontop = true
naughty.config.defaults.icon_size = dpi(32)
naughty.config.defaults.timeout = 5
naughty.config.defaults.title = 'System Notification'
naughty.config.defaults.margin = dpi(100)
naughty.config.defaults.border_width = 0
naughty.config.defaults.position = 'top_right'
naughty.config.defaults.screen = 1
naughty.config.defaults.shape = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, dpi(6)) end

-- Apply theme variables

naughty.config.padding = dpi(20)
naughty.config.spacing = dpi(20)
naughty.config.icon_dirs = {
    "/usr/share/icons/Papirus/",
    "/usr/share/icons/gnome/",
    "/usr/share/icons/hicolor/",
    "/usr/share/pixmaps/"
}
naughty.config.icon_formats = { "svg", "png", "jpg", "gif" }


-- Presets / rules

ruled.notification.connect_signal('request::rules', function()

    -- Critical notifs
    ruled.notification.append_rule {
        rule       = { urgency = 'critical' },
        properties = {
            font                = 'VictorMono Nerd Font 10',
            bg                      = '#ff0000',
            fg                      = '#ffffff',
            margin                  = dpi(16),
            position            = 'top_right',
            implicit_timeout    = 15
        }
    }

    -- Normal notifs
    ruled.notification.append_rule {
        rule       = { urgency = 'normal' },
        properties = {
            font                = 'VictorMono Nerd Font 10',
            bg                  = beautiful.transparent,
            fg                      = beautiful.fg_normal,
            margin                  = dpi(16),
            position            = 'top_right',
            implicit_timeout    = 8
        }
    }

    -- Low notifs
    ruled.notification.append_rule {
        rule       = { urgency = 'low' },
        properties = {
            font                = 'VictorMono Nerd Font 10',
            bg                      = beautiful.transparent,
            fg                      = beautiful.fg_normal,
            margin                  = dpi(16),
            position            = 'top_right',
            implicit_timeout    = 5
        }
    }
end)


-- Error handling
naughty.connect_signal(
    "request::display_error",
    function(message, startup)
        naughty.notification {
            urgency = "critical",
            title   = "Oops, an error happened"..(startup and " during startup!" or "!"),
            message = message,
            app_name = 'System Notification',
            icon = beautiful.awesome_icon
        }
    end
)

-- XDG icon lookup
naughty.connect_signal(
    "request::icon",
    function(n, context, hints)
        if context ~= "app_icon" then return end

        local path = menubar.utils.lookup_icon(hints.app_icon) or
            menubar.utils.lookup_icon(hints.app_icon:lower())

        if path then
            n.icon = path
        end
    end
)

-- Naughty template
naughty.connect_signal("request::display", function(n)

    -- naughty.actions template
    local actions_template = wibox.widget {
        notification = n,
        base_layout = wibox.widget {
            spacing        = dpi(4),
            layout         = wibox.layout.flex.horizontal
        },
        widget_template = {
            {
                {
                    {
                        {
                            id     = 'text_role',
                            font   = 'VictorMono Nerd Font 10',
                            widget = wibox.widget.textbox
                        },
                        widget = wibox.container.place
                    },
                    widget = clickable_container
                },
                bg                 = beautiful.groups_bg,
                shape              = gears.shape.rounded_rect,
                forced_height      = dpi(35),
                widget             = wibox.container.background
            },
            margins = dpi(8),
            widget  = wibox.container.margin
        },
        style = { underline_normal = false, underline_selected = true },
        widget = naughty.list.actions
    }
    -- Custom notification layout
    naughty.layout.box {
        notification = n,
        type = "notification",
        screen = awful.screen.preferred(),
        shape = gears.shape.rounded_rectangle,
        widget_template = {
            {
                {
                    {
                        {
                            {
                                {
                                    {
                                        {
                                            {
                                                {
                                                    {
                                                        markup = n.app_name or 'System Notification',
                                                        font = 'VictorMono Nerd Font 10',
                                                        align = 'center',
                                                        valign = 'center',
                                                        widget = wibox.widget.textbox
                                                    },
                                                    margins = beautiful.notification_margin,
                                                    widget  = wibox.container.margin,
                                                },
                                                bg = '#000000'.. '44',
                                                widget  = wibox.container.background,
                                            },
                                            {
                                                {
                                                    {
                                                        resize_strategy = 'center',
                                                        widget = naughty.widget.icon,
                                                    },
                                                    margins = beautiful.notification_margin,
                                                    widget  = wibox.container.margin,
                                                },
                                                {
                                                    {
                                                        layout = wibox.layout.align.vertical,
                                                        expand = 'none',
                                                        nil,
                                                        {
                                                            {
                                                                align = 'center',
                                                                widget = naughty.widget.title
                                                            },
                                                            {
                                                                align = "center",
                                                                widget = naughty.widget.message,
                                                            },
                                                            layout = wibox.layout.fixed.vertical
                                                        },
                                                        nil
                                                    },
                                                    margins = beautiful.notification_margin,
                                                    widget  = wibox.container.margin,
                                                },
                                                layout = wibox.layout.fixed.horizontal,
                                            },
                                            fill_space = true,
                                            spacing = beautiful.notification_margin,
                                            layout  = wibox.layout.fixed.vertical,
                                        },
                                        -- Margin between the fake background
                                        -- Set to 0 to preserve the 'titlebar' effect
                                        margins = dpi(0),
                                        widget  = wibox.container.margin,
                                    },
                                    bg = beautiful.bg_normal,
                                    widget  = wibox.container.background,
                                },
                                -- Notification action list
                                -- naughty.list.actions,
                                actions_template,
                                spacing = dpi(4),
                                layout  = wibox.layout.fixed.vertical,
                            },
                            bg     = beautiful.bg_normal,
                            id     = "background_role",
                            shape = gears.shape.rounded_rect,
                            widget = naughty.container.background,
                        },
                        strategy = "min",
                        width    = dpi(160),
                        widget   = wibox.container.constraint,
                    },
                    strategy = "max",
                    width    = beautiful.notification_max_width or dpi(500),
                    widget   = wibox.container.constraint,
                },
                -- Anti-aliasing container
                -- Real BG
                bg = beautiful.bg_normal,
                -- This will be the anti-aliased shape of the notification
                shape = gears.shape.rounded_rect,
                widget = wibox.container.background
            },
            -- Margin of the fake BG to have a space between notification and the screen edge
            -- margins = dpi(15),--beautiful.notification_margin,
            right = dpi(20),
            left = dpi(0),
            bottom = dpi(0),
            top = dpi(20),
            widget  = wibox.container.margin
        },
        bg = beautiful.transparent,
        widget = wibox.container.background
    }

    -- Destroy popups if dont_disturb mode is on
    -- Or if the right_panel is visible
    local focused = awful.screen.focused()
    if _G.dont_disturb or (focused.right_panel and focused.right_panel.visible) then
        naughty.destroy_all_notifications(nil, 1)
    end

end)