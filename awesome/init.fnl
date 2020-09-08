(local awful (require "awful"))
(local ruled (require "ruled"))
(local rules (require "rules"))
(local beautiful (require "beautiful"))
(local gears (require "gears"))
(local keys (require "keys"))

;; (gears.wallpaper.set (beautiful.wallpaper))

(set awful.rules.rules rules)

(root.keys keys.globalkeys)
