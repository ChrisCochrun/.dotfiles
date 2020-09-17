(local awful (require "awful"))
(local gears (require "gears"))
(local beautiful (require "beautiful"))
(local hotkeys_popup (require "awful.hotkeys_popup"))

(var modkey "Mod4")
(var alt "Mod1")
(var shift "Shift")
(var ctrl "Control")

(local globalkeys (awful.keyboard.append_global_keybindings [
                                                             (awful.key [ modkey alt ] "m" (awful.spawn "mpv --player-operation-mode=pseudo-gui")
                                                                        { :description "launch mpv" :group "apps" })
                                                             (awful.key [ modkey ] "s" hotkeys_popup.show_help
                                                                        { :description "show help" :group "awesome" })
                                                             ]))

globalkeys



    ;; -- mpv
    ;; awful.key({ modkey,  altkey   }, "m", function () awful.spawn("mpv --player-operation-mode=pseudo-gui") end,
              ;; {description = "open mpv", group = "apps"}),
