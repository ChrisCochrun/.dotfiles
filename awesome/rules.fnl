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
                 :buttons keybindings.clientbuttons
                 :screen awful.screen.preferred
                 :placement (+ awful.placement.no_overlap awful.placement.no_offscreen)
                 }
   }

  ;; floating
  {
   :rule_any {
              :class [
                      "mpv"
                      "dolphin"
                      ]
              :role [
                     "pop-up"
                     ]}
   :properties {:floating true}
   }
  ])

rules
