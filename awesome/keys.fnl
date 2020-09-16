(local awful (require "awful"))
(local beautiful (require "beautiful"))
(local hotkeys_popup (require "awful.hotkeys_popup"))


(local modifiers {
                  :mod "Mod4"
                  :shift "Shift"
                  :ctrl "Control"
                  :alt "Mod1"
                  })

(local globalkeys (awful.keyboard.append_global_keybindings [
                                                             (awful.key [:mod :alt] "m" (awful.spawn "mpv --player-operation-mode=pseudo-gui"))
                                                             (awful.key [:mod] "s" hotkeys_popup.show_help)
                                                             ]))

globalkeys



    ;; -- mpv
    ;; awful.key({ modkey,  altkey   }, "m", function () awful.spawn("mpv --player-operation-mode=pseudo-gui") end,
              ;; {description = "open mpv", group = "apps"}),
