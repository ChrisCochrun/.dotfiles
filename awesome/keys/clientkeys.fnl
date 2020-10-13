(local awful (require "awful"))
(local gears (require "gears"))
(local beautiful (require "beautiful"))

(global clientkeys
        (gears.table.join
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
                    {:description "(un)maximize horizontally" :group "client"})))

clientkeys
