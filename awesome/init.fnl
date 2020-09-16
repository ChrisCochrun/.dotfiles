(local awful (require "awful"))
(local ruled (require "ruled"))
(local rules (require "rules"))
(local beautiful (require "beautiful"))
(local gears (require "gears"))
(local keys (require "keys"))

;;; rules
(set awful.rules.rules rules)

;;; wallpaper
(fn set-wallpaper [s]
    (local wallpaper beautiful.wallpaper)
    (gears.wallpaper.maximized wallpaper s false))

(awful.screen.connect_for_each_screen set-wallpaper)
(screen.connect_signal "property::geometry" set-wallpaper)

;;; autostart applications
(awful.spawn.with_shell "picom --experimental-backend")
(awful.spawn.with_shell "xset r rate 220 90")
(awful.spawn.with_shell "/usr/lib/polkit-kde-authentication-agent-1")
(awful.spawn.with_shell "feh --bg-fill ~/Pictures/wallpapers/RoyalKing.png")
(awful.spawn.with_shell "flameshot")
(awful.spawn.with_shell "caffeine")
(awful.spawn.with_shell "nextcloud --background")
(awful.spawn.with_shell "emacs -daemon")
(awful.spawn.with_shell "libinput-gestures-setup start")
