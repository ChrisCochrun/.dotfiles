(local awful (require "awful"))
(local gears (require "gears"))
(local beautiful (require "beautiful"))
(local menubar (require "menubar"))

(local bar (fn [s]

   ;; Wallpaper
   (set_wallpaper s)

   ;; Each screen has its own tag table.
   (awful.tag [ "1" "2" "3" "4" ] s (. awful.layout.layouts 1))

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
                                             :filter awful.widget.tasklist.filter.currenttags
                                             :buttons tasklist_buttons
                                             }))

   (set s.mytextclock
        (wibox.widget (/<
                       :layout wibox.layout.fixed.horizontal
                       (/<
                        :format "<b> %a %b %d, %l:%M %p </b>"
                        :widget wibox.widget.textclock)
                       )))

   ;; Create the wibox
   (set s.mywibox (awful.wibar { :position "bottom" :screen s }))

   ;; Add widgets to the wibox
   (: s.mywibox :setup {
                        :layout wibox.layout.align.horizontal
                        1 { ;; Left widgets
                           :layout wibox.layout.fixed.horizontal
                           2 s.mytaglist
                           3 s.mypromptbox
                           }
                        2 s.mytasklist ;; Middle widget
                        3 { ;; Right widgets
                           :layout wibox.layout.fixed.horizontal
                           2 (wibox.widget.systray)
                           3 s.mytextclock
                           4 s.mylayoutbox
                           }
                        })
               ))

;; Menu
;; Create a launcher widget and a main menu
(local myawesomemenu [
                       [ "hotkeys" (fn [] (hotkeys_popup.show_help nil (awful.screen.focused))) ]
                       [ "manual" (.. terminal " -e man awesome") ]
                       [ "edit config" (.. editor_cmd " " awesome.conffile) ]
                       [ "restart" awesome.restart ]
                       [ "quit" (fn [] (awesome.quit)) ]])

(local mymainmenu (awful.menu {:items [
                                        [ "awesome" myawesomemenu beautiful.awesome_icon ]
                                        [ "open terminal" terminal ]]}))

(local mylauncher (awful.widget.launcher {:image beautiful.awesome_icon
                                           :menu mymainmenu }))

;; Keyboard map indicator and switcher
(local mykeyboardlayout (awful.widget.keyboardlayout))

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

;; (fn set_wallpaper [s]
;;   ;; Wallpaper
;;   (when beautiful.wallpaper
;;     (var wallpaper beautiful.wallpaper)
;;     ;; If wallpaper is a function, call it with the screen
;;     (when (= (type wallpaper) "function")
;;       (set wallpaper (wallpaper s)))
;;     (gears.wallpaper.maximized wallpaper s true)))

;; ;; Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
;; (screen.connect_signal "property::geometry" set_wallpaper)
bar
