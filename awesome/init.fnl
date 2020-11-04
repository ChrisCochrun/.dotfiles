;; Standard awesome library
(local gears (require "gears"))
(local awful (require "awful"))
(require "awful.autofocus")
;; Widget and layout library
(local wibox (require "wibox"))
;; Theme handling library
(local beautiful (require "beautiful"))
(local xresources (require "beautiful.xresources"))
;; Notification library
(local naughty (require "naughty"))
(local menubar (require "menubar"))
;; Enable hotkeys help widget for VIM and other apps
;; when client with a matching name is opened:
(local hotkeys_popup (require "awful.hotkeys_popup"))
(require "awful.hotkeys_popup.keys")
(local dpi xresources.apply_dpi)
(local ruled (require "ruled"))

;; my splits
(local rules (require "rules"))
(local keybindings (require "keybindings"))

;; (local bar (require "bar"))
;; Error handling
;; Check if awesome encountered an error during startup and fell back to
;; another config (This code will only ever execute for the fallback config)
(when awesome.startup_errors
  (naughty.notify {:preset naughty.config.presets.critical
                   :title "Oops, there were errors during startup!"
                   :text awesome.startup_errors}))

;; Handle runtime errors after startup
(do
  (var in_error false)
  (awesome.connect_signal "debug::error" (fn [err]
                                           ;; Make sure we don't go into an endless error loop
                                           (when (not in_error)
                                             (set in_error true)
                                             (naughty.notify {:preset naughty.config.presets.critical
                                                              :title "Oops, an error happened!"
                                                              :text (tostring err)})
                                             (set in_error false)))))

;; Variable definitions
;; Themes define colours, icons, font and wallpapers.
(beautiful.init "/home/chris/.config/awesome/theme.lua")

;; This is used later as the default terminal and editor to run.
(var terminal "alacritty")
(var editor (or (os.getenv "EDITOR") "emacsclient"))
(var editor_cmd (.. terminal " -e " editor))

;; (lambda battery-capacity (awful.spawn.easy_async "cat /sys/class/power_supply/BAT*/capacity"))

;; Default modkey.
;; Usually, Mod4 is the key with a logo between Control and Alt.
;; If you do not like this or do not have such a key,
;; I suggest you to remap Mod4 to another key using xmodmap or other tools.
;; However, you can use another modifier like Mod1, but it may interact with others.
(var modkey "Mod4")
(local shift "Shift")
(local ctrl "Control")
(local alt "Mod1")

;; Table of layouts to cover with awful.layout.inc, order matters.
(set awful.layout.layouts [
                           awful.layout.suit.tile
                           awful.layout.suit.floating
                           ;; awful.layout.suit.tile.left
                           ;; awful.layout.suit.tile.bottom
                           ;; awful.layout.suit.tile.top
                           awful.layout.suit.fair
                           ;; awful.layout.suit.fair.horizontal
                           awful.layout.suit.spiral
                           ;; awful.layout.suit.spiral.dwindle
                           awful.layout.suit.max
                           ;; awful.layout.suit.max.fullscreen
                           awful.layout.suit.magnifier
                           awful.layout.suit.corner.nw
                           ;; awful.layout.suit.corner.ne
                           ;; awful.layout.suit.corner.sw
                           ;; awful.layout.suit.corner.se
                           ])

;; Menu
;; Create a launcher widget and a main menu
(global myawesomemenu [
                       [ "hotkeys" (fn [] (hotkeys_popup.show_help nil (awful.screen.focused))) ]
                       [ "manual" (.. terminal " -e man awesome") ]
                       [ "edit config" (.. editor_cmd " " awesome.conffile) ]
                       [ "restart" awesome.restart ]
                       [ "quit" (fn [] (awesome.quit)) ]])

(global mymainmenu (awful.menu {:items [
                                        [ "awesome" myawesomemenu beautiful.awesome_icon ]
                                        [ "open terminal" terminal ]]}))

(global mylauncher (awful.widget.launcher {:image beautiful.awesome_icon
                                           :menu mymainmenu }))

;; Menubar configuration
(set menubar.utils.terminal terminal) ;; Set the terminal for applications that require it

;; Keyboard map indicator and switcher
(global mykeyboardlayout (awful.widget.keyboardlayout))

;; Wibar
;; Create a textclock widget
(global mytextclock (wibox.widget.textclock))

;; Create a wibox for each screen and add it
(local taglist_buttons
       (gears.table.join
        (awful.button [] 1 (fn [t] (: t :view_only)))
        (awful.button [ modkey ] 1 (fn [t] (when client.focus (: client.focus :move_to_tag t))))
        (awful.button [] 3 awful.tag.viewtoggle)
        (awful.button [ modkey ] 3 (fn [t] (when client.focus (: client.focus :toggle_tag t))))
        (awful.button [] 4 (fn [t] (awful.tag.viewnext t.screen)))
        (awful.button [] 5 (fn [t] (awful.tag.viewprev t.screen)))))


(local tasklist_buttons
       (gears.table.join
        (awful.button [] 1 (fn [c]
                             (if (= c client.focus)
                                 (set c.minimized true)
                                 (: c :emit_signal
                                    "request::activate"
                                    "tasklist"
                                    {:raise true}
                                    ))))
        (awful.button [] 3 (fn [] (awful.menu.client_list {:theme {:width 250 }})))
        (awful.button [] 4 (fn [] (awful.client.focus.byidx 1)))
        (awful.button [] 5 (fn [] (awful.client.focus.byidx -1)))))

(awful.screen.connect_for_each_screen
 (fn [s]

   ;; Each screen has its own tag table.
   (awful.tag [ "   " "   " "   " "   " ] s (. awful.layout.layouts 1))

     ;; Make buffers on all sides so that tiled clients aren't pushed to edges
     (set s.padding (dpi 10))

   ;; Create a promptbox for each screen
   (set s.mypromptbox (awful.widget.prompt))
   ;; Create an imagebox widget which will contain an icon indicating which layout we're using.
   ;; We need one layoutbox per screen.
   (set s.mylayoutbox (awful.widget.layoutbox s))
   (: s.mylayoutbox :buttons (gears.table.join
                              (awful.button [] 1 (fn [] (awful.layout.inc 1 s awful.layout.layouts)))
                              (awful.button [] 3 (fn [] (awful.layout.inc -1 s)))
                              (awful.button [] 4 (fn [] (awful.layout.inc 1 s)))
                              (awful.button [] 5 (fn [] (awful.layout.inc -1 s)))))
   ;; Create a taglist widget
   (set s.mytaglist (awful.widget.taglist {
                                           :screen s
                                           :filter awful.widget.taglist.filter.all
                                           :buttons taglist_buttons
                                           }))

   ;; Create a tasklist widget
   (set s.mytasklist (awful.widget.tasklist {
                                             :screen s
                                             :filter awful.widget.tasklist.filter.focused
                                             :buttons tasklist_buttons
                                             :style {
                                                     :border_width 0
                                                     :shape gears.shape.rounded_bar
                                                     :bg_focus beautiful.bg_normal
                                                     }
                                             :layout {
                                                      :spacing (dpi 20)
                                                      :spacing_widget {
                                                                       1 {
                                                                          :forced_width (dpi 5)                                                                          :forced_height (dpi 20)
                                                                          :widget wibox.widget.separator
                                                                          }
                                                                       :valign "center"
                                                                       :halign "center"
                                                                       :widget wibox.container.place
                                                                       }
                                                      :layout wibox.layout.flex.horizontal
                                                      }
                                             :widget_template {
                                                               1 {
                                                                  1 {
                                                                     1 {
                                                                        1 {
                                                                           :id "icon_role"
                                                                           :widget wibox.widget.imagebox
                                                                           }
                                                                        :margins 2
                                                                        :widget wibox.container.margin
                                                                        }
                                                                     2 {
                                                                        :id "text_role"
                                                                        :widget wibox.widget.textbox
                                                                        }
                                                                     :layout wibox.layout.align.horizontal
                                                                     }
                                                                  :left (dpi 10)
                                                                  :right (dpi 10)
                                                                  :widget wibox.container.margin
                                                                  }
                                                               :id "background_role"
                                                               :widget wibox.container.background
                                                               }
                                             }))

   (set s.myminimizedtasklist (awful.widget.tasklist {
                                             :screen s
                                             :filter awful.widget.tasklist.filter.minimizedcurrenttags
                                             :buttons tasklist_buttons
                                             :style {
                                                     :border_width 0
                                                     :shape gears.shape.rounded_bar
                                                     }
                                             :layout {
                                                      :spacing (dpi 20)
                                                      :spacing_widget {
                                                                       1 {
                                                                          :forced_width (dpi 5)                                                                          :forced_height (dpi 20)
                                                                          :widget wibox.widget.separator
                                                                          }
                                                                       :valign "center"
                                                                       :halign "center"
                                                                       :widget wibox.container.place
                                                                       }
                                                      :layout wibox.layout.flex.horizontal
                                                      }
                                             :widget_template {
                                                               1 {
                                                                  1 {
                                                                     1 {
                                                                        1 {
                                                                           :id "icon_role"
                                                                           :widget wibox.widget.imagebox
                                                                           }
                                                                        :margins 2
                                                                        :widget wibox.container.margin
                                                                        }
                                                                     2 {
                                                                        :id "text_role"
                                                                        :widget wibox.widget.textbox
                                                                        }
                                                                     :layout wibox.layout.align.horizontal
                                                                     }
                                                                  :left (dpi 10)
                                                                  :right (dpi 10)
                                                                  :widget wibox.container.margin
                                                                  }
                                                               :id "background_role"
                                                               :widget wibox.container.background
                                                               }
                                             }))

   (set s.mytextclock (wibox.widget {
                                     :layout wibox.layout.fixed.horizontal
                                     1 {
                                        :format "<b> %a %b %d, %l:%M %p </b>"
                                        :widget wibox.widget.textclock}}))

     (set s.myemptywidget (wibox.widget { ;; an empty widget for spacing things out
                           :text ""
                           :align ""
                           :valign ""
                           :widget wibox.widget.textbox}))

     ;; (set batterywidget (wibox.widget {
     ;;                                   :text battery1-capacity
     ;;                                   :align ""
     ;;                                   :valign ""
     ;;                                   :widget wibox.widget.textbox
     ;;                                   }))

     (set s.myrightwidgets {
                            1 {
                               :layout wibox.layout.fixed.horizontal
                               1 wibox.widget.systray
                               2 s.mylayoutbox
                               }
                            :widget wibox.container.background
                            })

     (local yoffset (dpi 45)) ;; variables to be used for placing the wibox
     (local xoffset (dpi 18))
   ;; Create the wibox
     (set s.mywibox (wibox {;; since we are using a wibox we have a lot we need to set
                            ;; as opposed to what we normally need to do with a wibar
                            :position "bottom"
                            :x (+ s.geometry.x xoffset)
                            :y (- s.geometry.height yoffset)
                            :height (dpi 30)
                            :width (- s.geometry.width (* xoffset 2))
                            :ontop false
                            :stretch false
                            :type "dock"
                            :shape gears.shape.rounded_bar
                            :bg beautiful.bg_normal
                            :fg beautiful.fg_normal
                            :opacity 0.65
                            :screen s }))

     (: s.mywibox :struts { :bottom (dpi 45) })

   ;; Add widgets to the wibox
   (: s.mywibox :setup {
                        :layout wibox.layout.align.horizontal
                        :expand "outside"
                        1 { ;; Left widgets
                           1 {
                              :layout wibox.layout.fixed.horizontal
                              1 s.mytaglist
                              2 s.mypromptbox
                              3 s.mytasklist ;; Middle widget
                              }
                           :left (dpi 10)
                           :right (dpi 10)
                           :widget wibox.container.margin
                           }
                        2 s.mytextclock
                        3 { ;; Right widgets
                           1 {
                              :layout wibox.layout.align.horizontal
                              1 s.myemptywidget
                              2 {
                                 1 s.myminimizedtasklist
                                 :left (dpi 10)
                                 :right (dpi 20)
                                 :widget wibox.container.margin
                                 }
                              3 s.myrightwidgets
                              }
                           :left (dpi 10)
                           :right (dpi 10)
                           :widget wibox.container.margin
                           }
                        })

     (set s.mywibox.visible true) ;; this is needed to ensure the raw wibox is shown. Wibar normally does this
     ))


;; Mouse bindings
(root.buttons (gears.table.join
               (awful.button [ ] 3 (fn [] (: mymainmenu :toggle)))
               (awful.button [ ] 4 awful.tag.viewnext)
               (awful.button [ ] 5 awful.tag.viewprev)))

(client.connect_signal "request::default_keybindings"
                       (fn []
                           (awful.keyboard.append_client_keybindings [
                                                                      (awful.key [modkey] "c" (fn [c] (: c :kill))
                                                                                 {:description "close" :group "client"})
                                                                      (awful.key [ modkey ] "f" (fn [c] (set c.fullscreen (not c.fullscreen)) (: c :raise))
                                                                                 {:description "toggle fullscreen" :group "client"})
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
                                                                                 {:description "(un)maximize horizontally" :group "client"})]
                                                                    
                           )))

(client.connect_signal "request::default_mousebindings"
                       (fn []
                           (awful.mouse.append_client_mousebindings [
                                                                     (awful.button [] 1 (fn [c] (: c :activate {:context "mouse_click"})))
                                                                     (awful.button [modkey] 1 (fn [c] (: c :activate {:context "mouse_click" :action "mouse_move"})))
                                                                     (awful.button [modkey] 3 (fn [c] (: c :activate {:context "mouse_click" :action "mouse_resize"})))
                                                                     ])))


;; Set keys
(root.keys keybindings.globalkeys)

;; Rules
(set awful.rules.rules rules)

;; Signals
;; Signal function to execute when a new client appears.
(client.connect_signal
 "manage"
 (fn [c]
   ;; Set the windows at the slave,
   ;; i.e. put it at the end of others instead of setting it master.
   (when (not awesome.startup) (awful.client.setslave c))

   (when (and awesome.startup
              (not c.size_hints.user_position)
              (not c.size_hints.program_position))
     ;; Prevent clients from being unreachable after screen count changes.
     (awful.placement.no_offscreen c))
     (awful.client.focus.byidx 1)
     (: c :activate [])))


(client.connect_signal "focus" (fn [c] (set c.border_color beautiful.border_focus)))
(client.connect_signal "unfocus" (fn [c] (set c.border_color beautiful.border_normal)))

(awful.spawn.with_shell "picom --experimental-backend")
(awful.spawn.with_shell "xset r rate 220 90")
(awful.spawn.with_shell "/usr/lib/polkit-kde-authentication-agent-1")
(awful.spawn.with_shell "feh --bg-fill ~/Pictures/wallpapers/RoyalKing.png")
(awful.spawn.with_shell "flameshot")
(awful.spawn.with_shell "caffeine")
(awful.spawn.with_shell "nextcloud --background")
(awful.spawn.with_shell "emacs --daemon")
(awful.spawn.with_shell "libinput-gestures-setup start")
(awful.spawn.with_shell "bluetoothctl power on")
