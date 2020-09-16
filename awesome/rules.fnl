(global awful (require "awful"))
(global beautiful (require "beautiful"))
(global keybindings (require "keys"))

(local
 rules
 [
  ;; All clients match this rule
  {
   :rule {  }
   :propertites {
                 :border-width beautiful.border_width
                 :border_color beautiful.border_normal
                 :focus true
                 :raise true
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
                :focus true
                :height 800
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
                :focus true
                :placement (+ awful.placement.no_offscreen awful.placement.centered)
                }
   }
  ])

rules
