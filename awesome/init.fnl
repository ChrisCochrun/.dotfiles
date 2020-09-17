(local awful (require "awful"))
(local gears (require "gears"))
(require "awful.autofocus")
(local ruled (require "ruled"))
(local rules (require "rules"))
(local beautiful (require "beautiful"))
(local keys (require "keys"))
(local wibox (require "wibox"))
(local xresources (require "beautiful.xresources"))
;; (local naughty (require "naughty"))
(local menubar (require "menubar"))
(local hotkeys_popup (require "awful.hotkeys_popup"))
(local dpi xresources.apply_dpi)

;;; rules
(set awful.rules.rules rules)

;;; wallpaper
(fn set_wallpaper [s]
  ;; Wallpaper
  (when beautiful.wallpaper
    (var wallpaper beautiful.wallpaper)
    ;; If wallpaper is a function, call it with the screen
    (when (= (type wallpaper) "function")
      (set wallpaper (wallpaper s)))
    (gears.wallpaper.maximized wallpaper s true)))

;; Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
(screen.connect_signal "property::geometry" set_wallpaper)

(local mykeyboardlayout (awful.widget.keyboardlayout))
(local mytextclock (wibox.widget.textclock " %a %b %d, %l:%M %p "))


;;; panel
;; (awful.screen.connect_for_each_screen
;;  (fn [s]
;;      ;; Wallpaper
;;      (set_wallpaper s)

;;      ;; Each screen has its own tag table.
;;      (awful.tag [ "" "" "" "" ] s (. awful.layout.layouts 1))

;;      ;; Create a promptbox for each screen
;;      (set s.mypromptbox (awful.widget.prompt))
;;      ;; Create an imagebox widget which will contain an icon indicating which layout we're using.
;;      ;; We need one layoutbox per screen.
;;      (set s.mylayoutbox (awful.widget.layoutbox s))
;;      (: s.mylayoutbox :buttons (gears.table.join
;;                               (awful.button [] 1 (fn [] (awful.layout.inc 1 s awful.layout.layouts)))
;;                               (awful.button [] 3 (fn [] (awful.layout.inc -1 s)))
;;                               (awful.button [] 4 (fn [] (awful.layout.inc 1 s)))
;;                               (awful.button [] 5 (fn [] (awful.layout.inc -1 s)))))

;;      ;; create a systray widget
;;      (set s.mysystray {
;;                        1 (wibox.widget.systray)
;;                        :widget wibox.container.background
;;                        })
;;      ;; Create a taglist widget
;;      (set s.mytaglist (awful.widget.taglist {
;;                                              :screen s
;;                                              :filter awful.widget.taglist.filter.all
;;                                              :buttons taglist_buttons
;;                                              }))

;;      ;; Create a tasklist widget
;;      (set s.mytasklist (awful.widget.tasklist {
;;                                                :screen s
;;                                                :filter awful.widget.tasklist.filter.currenttags
;;                                                :buttons tasklist_buttons
;;                                                :style {
;;                                                        :border_width 0
;;                                                        :border_color "#777777"
;;                                                        :shape gears.shape.rounded_bar
;;                                                        }
;;                                                :layout {
;;                                                         :spacing 20
;;                                                         :spacing_widget {
;;                                                                          1 {
;;                                                                             :forced_width 5
;;                                                                             :forced_height (dpi 20)
;;                                                                             :widget wibox.widget.seperator
;;                                                                             }
;;                                                                          :valign "center"
;;                                                                          :halign "center"
;;                                                                          :widget wibox.container.place
;;                                                                          }
;;                                                         :layout wibox.layout.flex.horizontal                                                      }
;;                                                }
;;                                               :widget_template {
;;                                                                 1 {
;;                                                                    1 {
;;                                                                       1 {
;;                                                                          1 {
;;                                                                             :id "icon_role"
;;                                                                             :widget wibox.widget.imagebox
;;                                                                             }
;;                                                                          :margins 2
;;                                                                          :widget wibox.container.margin
;;                                                                          }
;;                                                                       2 {
;;                                                                          :id "text_role"
;;                                                                          :widget wibox.widget.textbox
;;                                                                          }
;;                                                                       :layout wibox.layout.align.horizontal
;;                                                                       }
;;                                                                    :left 10
;;                                                                    :right 10
;;                                                                    :widget wibox.container.margin
;;                                                                    }
;;                                                                 :id "background_role"
;;                                                                 :widget wibox.container.background}))

;;      ;; create battery network and volume widgets
;;      (set s.battery (require widget.battery))
;;      (set s.volume (require widget.volume))
;;      (set s.updater (require widget.package-updater))

;;      ;; create right widgets
;;      (set s.myrightwidgets {
;;                             1 {
;;                                :layout wibox.layout.fixed.horizontal
;;                                1 s.volume
;;                                2 s.mysystray
;;                                3 s.updater
;;                                4 s.battery
;;                                5 (wibox.container.margin (s.mylayoutbox 0 (dpi 25) 0 0))
;;                                }
;;                             :widget wibox.container.background})

;;      ;; empty widget to use for spacing
;;      (set s.myemptywidget (wibox.widget {
;;                                          :markup ""
;;                                          :align ""
;;                                          :valign ""
;;                                          :widget wibox.widget.textbox
;;                                          }))

;;      (local yoffset (dpi 45))
;;      (local xoffset (dpi 18))
;;      (set s.mypanel (wibox.wibox {
;;                                   :x (+ s.geometry.x xoffset)
;;                                   :y (- s.geometry.height yoffset)
;;                                   :height (dpi 30)
;;                                   :width (- s.geometry.width (* xoffset 2))
;;                                   :ontop false
;;                                   :stretch false
;;                                   :type "dock"
;;                                   :shape gears.shape.rounded_bar
;;                                   :bg beautiful.bg_normal
;;                                   :fg beautiful.fg_normal
;;                                   :opacity 0.65
;;                                   }))
;;      (: s.mypanel :struts {
;;                            :bottom (dpi 40)
;;                            })
;;      (: s.mypanel :setup {
;;                           :layout wibox.layout.align.horizontal
;;                           :expand "outside"
;;                           1 {
;;                              :layout wibox.layout.align.horizontal
;;                              1 (wibox.container.margin (s.mytaglist (dpi 15) 0 (dpi -3) 0))
;;                              2 (wibox.container.margin (s.mytasklist (dpi 25) (dpi 25) 0 0))
;;                              3 s.myemptywidget
;;                              :spacing (dpi 15)
;;                              }
;;                           2 mytextclock
;;                           3 {
;;                              :layout wibox.layout.align.horizontal
;;                              1 s.myemptywidget
;;                              2 (wibox.container.margin (s.mypromptbox (dpi 25) (dpi 25) 0 0))
;;                              3 s.myrightwidgets
;;                              }
;;                           :visible true
;;                           })
;;      ))





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
