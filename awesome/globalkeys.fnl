(local awful (require "awful"))
(local gears (require "gears"))
(local beautiful (require "beautiful"))
(local hotkeys_popup (require "awful.hotkeys_popup"))

(var mod "Mod4")
(var shift "Shift")
(var ctrl "Control")
(var alt "Mod1'")

(global globalkeys (gears.table.join
                 (awful.key [mod alt] "m" (awful.spawn "mpv --player-operation-mode=pseudo-gui")
                      { :description "launch mpv" :group "apps" })
                 (awful.key [mod] "s" hotkeys_popup.show_help
                      { :description "show help" :group "awesome" })))

globalkeys



    ;; -- mpv
    ;; awful.key({ modkey,  altkey   }, "m", function () awful.spawn("mpv --player-operation-mode=pseudo-gui") end,
              ;; {description = "open mpv", group = "apps"}),
