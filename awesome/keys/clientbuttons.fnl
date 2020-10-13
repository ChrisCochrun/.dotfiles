(local awful (require "awful"))
(local gears (require "gears"))
(local beautiful (require "beautiful"))

(global clientbuttons
        (gears.table.join
         (awful.button [] 1 (fn [c] (: c :emit_signal "request::activate" "mouse_click" {:raise true})))
         (awful.button [ modkey ] 1 (fn [c]
                                      (: c :emit_signal "request::activate" "mouse_click" {:raise true})
                                      (awful.mouse.client.move c)))
         (awful.button [ modkey ] 3 (fn [c]
                                      (: c :emit_signal "request::activate" "mouse_click" {:raise true})
                                      (awful.mouse.client.resize c)))))

clientbuttons
