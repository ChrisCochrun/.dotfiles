(local awful (require "awful"))
(local gears (require "gears"))
(local beautiful (require "beautiful"))
(local hotkeys_popup (require "awful.hotkeys_popup"))


(local terminal "alacritty")
(local modkey "Mod4")
(local shift "Shift")
(local ctrl "Control")
(local alt "Mod1")

(fn get-volume [?callback]
    (let [cb (or ?callback (fn [] nil))]
      (awful.spawn.easy_async_with_shell "pamixer --get-volume-human" cb)))

(local keybindings
       {
        :globalkeys (gears.table.join
                     (awful.key [ modkey ] "s" hotkeys_popup.show_help
                                { :description "show help" :group "awesome"})
                     (awful.key [ modkey ] "Left" awful.tag.viewprev
                                {:description "view previous" :group "tag"})
                     (awful.key [ modkey ] "Right" awful.tag.viewnext
                                {:description "view next" :group "tag"})
                     (awful.key [ modkey ] "Escape" awful.tag.history.restore
                                {:description "go back" :group "tag"})
                     (awful.key [ modkey ] "j" (fn [] (awful.client.focus.byidx 1))
                                {:description "focus next by index" :group "client"})
                     (awful.key [ modkey ] "k" (fn [] (awful.client.focus.byidx -1))
                                {:description "focus previous by index" :group "client"})

                     ;; Layout manipulation
                     (awful.key [ modkey shift ] "j" (fn [] (awful.client.swap.byidx 1))
                                {:description "swap with next client by index" :group "client"})
                     (awful.key [ modkey shift ] "k" (fn [] (awful.client.swap.byidx -1))
                                {:description "swap with previous client by index" :group "client"})
                     (awful.key [ modkey ctrl ] "j" (fn [] (awful.screen.focus_relative 1))
                                {:description "focus the next screen" :group "screen"})
                     (awful.key [ modkey ctrl ] "k" (fn [] (awful.screen.focus_relative -1))
                                {:description "focus the previous screen" :group "screen"})
                     (awful.key [ modkey ] "u" awful.client.urgent.jumpto
                                {:description "jump to urgent client" :group "client"})
                     (awful.key [ modkey ] "Tab" (fn []
                                                     (awful.client.focus.history.previous)
                                                     (when client.focus (: client.focus :raise)))
                                {:description "go back" :group "client"})

                     ;; Standard program
                     (awful.key [ modkey ] "Return" (fn [] (awful.spawn terminal))
                                {:description "open a terminal" :group "launcher"})
                     (awful.key [ modkey ctrl ] "r" awesome.restart
                                {:description "reload awesome" :group "awesome"})
                     (awful.key [ modkey shift ] "q" awesome.quit
                                {:description "quit awesome" :group "awesome"})

                     ;; layout
                     (awful.key [ modkey ] "l" (fn [] (awful.tag.incmwfact 0.05))
                                {:description "increase master width factor" :group "layout"})
                     (awful.key [ modkey ] "h" (fn [] (awful.tag.incmwfact -0.05))
                                {:description "decrease master width factor" :group "layout"})
                     (awful.key [ modkey shift ] "h" (fn [] (awful.tag.incnmaster 1 nil true))
                                {:description "increase the number of master clients" :group "layout"})
                     (awful.key [ modkey shift ] "l" (fn [] (awful.tag.incnmaster -1 nil true))
                                {:description "decrease the number of master clients" :group "layout"})
                     (awful.key [ modkey ctrl ] "h" (fn [] (awful.tag.incncol 1 nil true))
                                {:description "increase the number of columns" :group "layout"})
                     (awful.key [ modkey ctrl ] "l" (fn [] (awful.tag.incncol -1 nil true))
                                {:description "decrease the number of columns" :group "layout"})
                     (awful.key [ modkey ] "space" (fn [] (awful.layout.inc 1))
                                {:description "select next" :group "layout"})
                     (awful.key [ modkey shift ] "space" (fn [] (awful.layout.inc -1))
                                {:description "select previous" :group "layout"})
                     (awful.key [ modkey ctrl ] "n" (fn []
                                                        (local c (awful.client.restore))
                                                        (when c ;; Focus restored client
                                                          (: c :emit_signal "request::activate" "key.unminimize" {:raise true})))
                                {:description "restore minimized" :group "client"})

                     ;; Prompt
                     (awful.key [ modkey ] "r" (fn [] (awful.spawn "/home/chris/.dotfiles/rofi/launchers-git/run.sh"))
                                {:description "run prompt" :group "launcher"})

                     (awful.key [ modkey shift ctrl ] "x" (fn []
                                                   (let [fscr (awful.screen.focused)]
                                                     (awful.prompt.run {
                                                                        :prompt       "Run Lua code: "
                                                                        :textbox      fscr.mypromptbox.widget
                                                                        :exe_callback awful.util.eval
                                                                        :history_path (.. (awful.util.get_cache_dir) "/history_eval")
                                                                        })))
                                {:description "lua execute prompt" :group "awesome"})

                     ;; utilities
                     (awful.key [] "Print" (fn [] (awful.spawn "flameshot gui"))
                                {:description "screenshot" :group "utilities"})
                     (awful.key [ modkey ] "." (fn [] (awful.spawn "/home/chris/.dotfiles/rofi/launchers-git/emoji.sh"))
                                {:description "emoji picker" :group "utilities"})
                     (awful.key [] "XF86MonBrightnessUp" (fn [] (awful.spawn
                                                                  "light -A 5"))
                                {:description "Increase monitor brightness by 5%" :group "utilities"})
                     (awful.key [] "XF86MonBrightnessDown" (fn [] (awful.spawn
                                                                  "light -U 5"))
                                {:description "Decrease monitor brightness by 5%" :group "utilities"})
                     ;; Menubar
                     ;; (awful.key [ modkey ] "p" (fn [] (menubar.show))
                     ;;            {:description "show the menubar" :group "launcher"})

                     ;; Programs
                     (awful.key [ modkey ] "d" (fn [] (awful.spawn "emacsclient -c -e '(dired-jump)'"))
                                {:description "launch dired in new emacs frame" :group "apps" })
                     (awful.key [ modkey ] "x" (fn [] (awful.spawn "emacsclient -c -e '(+org-capture/open-frame)'"))
                                {:description "launch scratchpad in new emacs frame" :group "apps" })
                     (awful.key [ modkey alt ] "m" (fn [] (awful.spawn "emacsclient -c -e '(org-roam-capture)'"))
                                {:description "launch scratchpad in new emacs frame" :group "apps" })
                     (awful.key [ modkey shift ] "x" (fn [] (awful.spawn "emacsclient -c -e '(doom/switch-to-scratch-buffer)'"))
                                {:description "launch scratchpad in new emacs frame" :group "apps" })
                     (awful.key [ modkey ] "i" (fn [] (awful.spawn "emacsclient -c -e '(mu4e)'"))
                                {:description "launch mu4e in new emacs frame" :group "apps" })
                     (awful.key [ modkey shift ] "Return" (fn [] (awful.spawn "emacsclient -c -e '(+eshell/frame)'"))
                                {:description "launch eshell in new emacs frame" :group "apps" })
                     (awful.key [ modkey ] "e" (fn [] (awful.spawn "env GDK_SCALE=2 emacsclient -c -a 'emacs'"))
                                {:description "launch new emacs frame" :group "apps" })
                     ;; rofi
                     (awful.key [] "Menu" (fn [] (awful.spawn "/home/chris/.dotfiles/rofi/launchers-git/launcher.sh"))
                                {:description "launch rofi" :group "launcher"})
                     (awful.key [modkey] "w" (fn [] (awful.spawn "/home/chris/.dotfiles/rofi/launchers-git/windows.sh"))
                                {:description "launch rofi window switcher" :group "launcher"})
                     (awful.key [modkey] "b" (fn [] (awful.spawn "bwmenu"))
                                {:description "launch rofi bitwarden selector" :group "launcher"})
                     ;; audio
                     (awful.key [modkey] "a" (fn [] (awful.spawn "urxvt -e pulsemixer" {
                                                                                            :floating true
                                                                                            :placement awful.placement.centered
                                                                                            }))
                                {:description "launch pacmixer" :group "audio"})
                     (awful.key [] "XF86AudioRaiseVolume" (fn [] (awful.spawn.with_shell
                                                                  "pactl set-sink-volume @DEFAULT_SINK@ +5% && paplay /usr/share/sounds/freedesktop/stereo/audio-volume-change.oga"))
                                {:description "Increase volume by 5%" :group "audio"})
                     (awful.key [] "XF86AudioLowerVolume" (fn [] (awful.spawn.with_shell
                                                                  "pactl set-sink-volume @DEFAULT_SINK@ -5% && paplay /usr/share/sounds/freedesktop/stereo/audio-volume-change.oga"))
                                {:description "Decrease volume by 5%" :group "audio"})
                     (awful.key [] "XF86AudioMute" (fn [] (awful.spawn.with_shell
                                                                  "pactl set-sink-mute @DEFAULT_SINK@ toggle && paplay /usr/share/sounds/freedesktop/stereo/audio-volume-change.oga"))
                                {:description "Mute volume" :group "audio"})
                     (awful.key [] "XF86Launch8" (fn [] (awful.spawn.with_shell
                                                                  "pactl set-source-mute @DEFAULT_SOURCE@ toggle"))
                                {:description "Mute microphone" :group "audio"})

                     ;; Because I don't know much fennel yet I'm doing each one individually
                     ;; View tags only.
                     (awful.key [ modkey ] "1"
                                (fn []
                                    (let [screen (awful.screen.focused)
                                          tag    (. screen.tags 1)]
                                      (when tag
                                        (: tag :view_only))))
                                {:description "view tag #1" :group "tag"})
                     (awful.key [ modkey ] "2"
                                (fn []
                                    (let [screen (awful.screen.focused)
                                          tag    (. screen.tags 2)]
                                      (when tag
                                        (: tag :view_only))))
                                {:description "view tag #2" :group "tag"})
                     (awful.key [ modkey ] "3"
                                (fn []
                                    (let [screen (awful.screen.focused)
                                          tag    (. screen.tags 3)]
                                      (when tag
                                        (: tag :view_only))))
                                {:description "view tag #3" :group "tag"})
                     (awful.key [ modkey ] "4"
                                (fn []
                                    (let [screen (awful.screen.focused)
                                          tag    (. screen.tags 4)]
                                      (when tag
                                        (: tag :view_only))))
                                {:description "view tag #4" :group "tag"})
                     (awful.key [] "XF86Tools"
                                (fn []
                                    (let [screen (awful.screen.focused)
                                          tag    (. screen.tags 1)]
                                      (when tag
                                        (: tag :view_only))))
                                {:description "view tag #1" :group "tag"})
                     (awful.key [] "XF86Launch5"
                                (fn []
                                    (let [screen (awful.screen.focused)
                                          tag    (. screen.tags 2)]
                                      (when tag
                                        (: tag :view_only))))
                                {:description "view tag #2" :group "tag"})
                     (awful.key [] "XF86Launch6"
                                (fn []
                                    (let [screen (awful.screen.focused)
                                          tag    (. screen.tags 3)]
                                      (when tag
                                        (: tag :view_only))))
                                {:description "view tag #3" :group "tag"})
                     (awful.key [] "XF86Launch7"
                                (fn []
                                    (let [screen (awful.screen.focused)
                                          tag    (. screen.tags 4)]
                                      (when tag
                                        (: tag :view_only))))
                                {:description "view tag #4" :group "tag"})
                     ;; Move client to tag
                     (awful.key [ modkey shift ] "1"
                                (fn []
                                    (when client.focus
                                      (let [tag (. client.focus.screen.tags 1)]
                                        (when tag
                                          (: client.focus :move_to_tag tag)))))
                                {:description "move focused client to tag #1" :group "tag"})
                     (awful.key [ modkey shift ] "2"
                                (fn []
                                    (when client.focus
                                      (let [tag (. client.focus.screen.tags 2)]
                                        (when tag
                                          (: client.focus :move_to_tag tag)))))
                                {:description "move focused client to tag #2" :group "tag"})
                     (awful.key [ modkey shift ] "3"
                                (fn []
                                    (when client.focus
                                      (let [tag (. client.focus.screen.tags 3)]
                                        (when tag
                                          (: client.focus :move_to_tag tag)))))
                                {:description "move focused client to tag #3" :group "tag"})
                     (awful.key [ modkey shift ] "4"
                                (fn []
                                    (when client.focus
                                      (let [tag (. client.focus.screen.tags 4)]
                                        (when tag
                                          (: client.focus :move_to_tag tag)))))
                                {:description "move focused client to tag #4" :group "tag"})
                     ;; Toggle tag display. Not working yet, can't pinpoint the problem.
                     (awful.key [ modkey ctrl ] "1"
                                (fn []
                                    (let [screen (awful.screen.focused)
                                          tag    (. screen.tags 1)]
                                      (when tag
                                        (awful.tag.viewtoggle))))
                                {:description "toggle tag #1" :group "tag"})
                     (awful.key [ modkey ctrl ] "2"
                                (fn []
                                    (let [screen (awful.screen.focused)
                                          tag    (. screen.tags 2)]
                                      (when tag
                                        (awful.tag.viewtoggle))))
                                {:description "toggle tag #2" :group "tag"})
                     (awful.key [ modkey ctrl ] "3"
                                (fn []
                                    (let [screen (awful.screen.focused)
                                          tag    (. screen.tags 3)]
                                      (when tag
                                        (awful.tag.viewtoggle))))
                                {:description "toggle tag #3" :group "tag"})
                     (awful.key [ modkey ctrl ] "4"
                                (fn []
                                    (let [screen (awful.screen.focused)
                                          tag    (. screen.tags 4)]
                                      (when tag
                                        (awful.tag.viewtoggle))))
                                {:description "toggle tag #4" :group "tag"})
                   ;; Toggle tag on focused client.
                   (awful.key [ modkey ctrl shift ] "1"
                              (fn []
                                (when client.focus
                                  (let [tag (. client.focus.screen.tags 1)]
                                    (when tag
                                      (: client.focus :toggle_tag tag)))))
                              {:description "toggle focused client on tag #1" :group "tag"})
                   (awful.key [ modkey ctrl shift ] "2"
                              (fn []
                                (when client.focus
                                  (let [tag (. client.focus.screen.tags 2)]
                                    (when tag
                                      (: client.focus :toggle_tag tag)))))
                              {:description "toggle focused client on tag #2" :group "tag"})
                   (awful.key [ modkey ctrl shift ] "3"
                              (fn []
                                (when client.focus
                                  (let [tag (. client.focus.screen.tags 3)]
                                    (when tag
                                      (: client.focus :toggle_tag tag)))))
                              {:description "toggle focused client on tag #3" :group "tag"})
                   (awful.key [ modkey ctrl shift ] "4"
                              (fn []
                                (when client.focus
                                  (let [tag (. client.focus.screen.tags 4)]
                                    (when tag
                                      (: client.focus :toggle_tag tag)))))
                              {:description "toggle focused client on tag #4" :group "tag"})
                     )


        :clientkeys (gears.table.join
                     (awful.key [ modkey ] "f" (fn [c] (set c.fullscreen (not c.fullscreen)) (: c :raise))
                                {:description "toggle fullscreen" :group "client"})
                     (awful.key [ modkey ] "c" (fn [c] (: c :kill))
                                {:description "close" :group "client"})
                     (awful.key [ modkey ctrl ] "space" awful.client.floating.toggle
                                {:description "toggle floating" :group "client"})
                     (awful.key [ modkey ctrl ] "Return" (fn [c] (: c :swap (awful.client.getmaster)))
                                {:description "move to master" :group "client"})
                     (awful.key [ modkey ] "o" (fn [c] (: c :move_to_screen))
                                {:description "move to screen" :group "client"})
                     (awful.key [ modkey ] "t" (fn [c] (set c.ontop (not c.ontop)))
                                {:description "toggle keep on top" :group "client"})
                     (awful.key [ modkey ] "n" (fn [c]
                                                   ;; The client currently has the input focus, so it cannot be
                                                   ;; minimized, since minimized clients can't have the focus.
                                                   (set c.minimized true))
                                {:description "minimize" :group "client"})
                     (awful.key [ modkey ] "m" (fn [c] (set c.maximized (not c.maximized)) (: c :raise))
                                {:description "(un)maximize" :group "client"})
                     (awful.key [ modkey ctrl ] "m" (fn [c] (set c.maximized_vertical (not c.maximized_vertical)) (: c :raise))
                                {:description "(un)maximize vertically" :group "client"})
                     (awful.key [modkey shift ] "m" (fn [c] (set c.maximized_horizontal (not c.maximized_horizontal)) (: c :raise))
                                {:description "(un)maximize horizontally" :group "client"}))

        :clientbuttons (gears.table.join
                        (awful.button [] 1 (fn [c] (: c :emit_signal "request::activate" "mouse_click" {:raise true})))
                        (awful.button [ modkey ] 1 (fn [c]
                                                       (: c :emit_signal "request::activate" "mouse_click" {:raise true})
                                                       (awful.mouse.client.move c)))
                        (awful.button [ modkey ] 3 (fn [c]
                                                       (: c :emit_signal "request::activate" "mouse_click" {:raise true})
                                                       (awful.mouse.client.resize c))))
        }
       )



keybindings
