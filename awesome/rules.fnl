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
                 :focus awful.client.focus.filter
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
                :placement awful.placement.centered
                :floating true
                }
   }
  ])

rules
