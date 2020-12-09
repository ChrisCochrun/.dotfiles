(local awful (require "awful"))
(local gears (require "gears"))
(local beautiful (require "beautiful"))
(local keybindings (require "keybindings"))
(local dpi xresources.apply_dpi)

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
                             ;; :shape gears.shape.rounded_rect
                             }
               }

              ;; floating and centered videos from mpv or firefox pnp
              {
               :rule_any {
                          :class [
                                  "mpv"
                                  ]
                          :name [
                                  "Picture-in-Picture"
                                  ]
                          }
               :properties {
                            :floating true
                            :raise true
                            :height (dpi 900)
                            :screen (screen.count)
                            :placement (+ awful.placement.no_offscreen awful.placement.centered)
                            }
               }
              ;; sxiv floating on main screen for quick picture viewing
              {
               :rule_any {
                          :class [
                                  "sxiv"
                                  "Sxiv"
                                  ]
                          }
               :properties {
                            :floating true
                            :raise true
                            :height 900
                            :width 1500
                            :placement (+ awful.placement.no_offscreen awful.placement.centered)
                            }
               }
              ;; Tell qb to open primarily on the secondary monitor
              {
               :rule_any {
                          :class [
                                  "qutebrowser"
                                  ]
                          }
               :properties {
                            :screen (screen.count)
                            }
               }
              ;; floating windows
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
