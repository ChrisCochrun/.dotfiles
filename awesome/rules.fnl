(local awful (require "awful"))
(local beautiful (require "beautiful"))
(local keybindings (require "keybindings"))

;; (local modkey "Mod4")

;; (local keys (gears.table.join
;;          ;; (awful.key [ modkey ] "f" (fn [c] (set c.fullscreen (not c.fullscreen)) (: c :raise))
;;          ;;            {:description "toggle fullscreen" :group "client"})
;;                  (awful.key [ modkey "Shift" ] "c" (fn [c] (: c :kill))
;;                             {:description "close" :group "client"})
;;          ;; (awful.key [ modkey "Control" ] "space" awful.client.floating.toggle
;;          ;;            {:description "toggle floating" :group "client"})
;;          ;; (awful.key [ modkey "Control" ] "Return" (fn [c] (: c :swap (awful.client.getmaster)))
;;          ;;            {:description "move to master" :group "client"})
;;          ;; (awful.key [ modkey ] "o" (fn [c] (: c :move_to_screen))
;;          ;;            {:description "move to screen" :group "client"})
;;          ;; (awful.key [ modkey ] "t"(fn [c] (set c.ontop (not c.ontop)))
;;          ;;            {:description "toggle keep on top" :group "client"})
;;          ;; (awful.key [ modkey ] "n" (fn [c]
;;          ;;                             ;; The client currently has the input focus, so it cannot be
;;          ;;                             ;; minimized, since minimized clients can't have the focus.
;;          ;;                             (set c.minimized true))
;;          ;;            {:description "minimize" :group "client"}),
;;          ;; (awful.key [ modkey ] "m" (fn [c] (set c.maximized (not c.maximized)) (: c :raise))
;;          ;;            {:description "(un)maximize" :group "client"}),
;;          ;; (awful.key [ modkey "Control" ] "m" (fn [c] (set c.maximized_vertical (not c.maximized_vertical)) (: c :raise))
;;          ;;            {:description "(un)maximize vertically" :group "client"}),
;;          ;; (awful.key [modkey "Shift" ] "m" (fn [c] (set c.maximized_horizontal (not c.maximized_horizontal)) (: c :raise))
;;          ;;            {:description "(un)maximize horizontally" :group "client"})
;;                 )
;;        )


;; (global clientbuttons
;;         (gears.table.join
;;          (awful.button [] 1 (fn [c] (: c :emit_signal "request::activate" "mouse_click" {:raise true})))
;;          (awful.button [ modkey ] 1 (fn [c]
;;                                       (: c :emit_signal "request::activate" "mouse_click" {:raise true})
;;                                       (awful.mouse.client.move c)))
;;          (awful.button [ modkey ] 3 (fn [c]
;;                                       (: c :emit_signal "request::activate" "mouse_click" {:raise true})
;;                                       (awful.mouse.client.resize c)))))

(local rules [
              ;; All clients match this rule
              {
               :rule {  }
               :propertites {
                             :border-width beautiful.border_width
                             :border_color beautiful.border_normal
                             :focus awful.client.focus.filter
                             :raise true
                             ;; :keys keys
                             ;; :buttons clientbuttons
                             :screen awful.screen.preferred
                             :placement (+ awful.placement.no_overlap awful.placement.no_offscreen)
                             }
               }

              ;; floating and centered
              {
               :rule_any {
                          :class [
                                  "mpv"
                                  ]
                          }
               :properties {
                            :floating true
                            :raise true
                            :height 900
                            :screen 2
                            :placement (+ awful.placement.no_offscreen awful.placement.centered)
                            }
               }
              {
               :rule_any {
                          :class [
                                  "dolphin"
                                  "feh"
                                  "Arandr"
                                  ]
                          :name [
                                 "Event Tester"
                                 "remove images?"
                                 ]
                          :role [
                                 "pop-up"
                                 "GtkFileChooserDialog"
                                 ]}
               :properties {
                            :floating true
                            :raise true
                            :placement (+ awful.placement.no_offscreen awful.placement.centered)
                            }
               }
              ])

rules
