(local awful (require "awful"))
(local beautiful (require "beautiful"))
(local wibox (require "wibox"))
(local dpi xresources.apply_dpi)


(awful.screen.connect_for_each_screen(fn screen_bar [s]
                                         "Adding a bar for each screen"
                                         (awful.tag([ "◉", "◉", "◉", "◉"] s awful.layout.layouts[1]))

                                         (let [yoffset (dpi 45)])
                                         (let [xoffset (dpi 18)])
                                         (let [mypanel (wibox
                                                         [
                                                          (let x (+ s.geometry.x xoffset))
                                                          (let y (- s.geometry.height yoffset))
                                                          (let height (dpi 30))
                                                          ])])
                                         ))
