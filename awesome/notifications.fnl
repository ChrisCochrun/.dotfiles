(local awful (require "awful"))
(local gears (require "gears"))
(local beautiful (require "beautiful"))
(local keybindings (require "keybindings"))
(local xresources (require "beautiful.xresources"))
(local dpi xresources.apply_dpi)
(local ruled (require "ruled"))

(local rules)
(ruled.notification.connect_signal "request::rules" (ruled.notification.append_rules
 [
  ;; All notifications match this rule
  {
   :rule {  }
   :propertites {
                 :border-width beautiful.border_width
                 :border_color beautiful.border_normal
                 :opacity 0.7
                 :shape gears.shape.rounded_rect
                 }
   }
  ]))



rules
