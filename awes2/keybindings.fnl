(local awful (require "awful"))
(local gears (require "gears"))
(local beautiful (require "beautiful"))
(local hotkeys_popup (require "awful.hotkeys_popup"))


(local terminal "alacritty")
(local modkey "Mod4")
(local shift "Shift")
(local ctrl "Control")
(local alt "Mod1")


;; key bindings
(global globalkeys
      (gears.table.join
       (awful.key [ modkey ] "s" hotkeys_popup.show_help
                  { :description "show help" :group "awesome"})
       (awful.key [ modkey ] "Left" awful.tag.viewprev
                  {:description "view previous" :group "tag"})
       (awful.key [ modkey ] "Right" awful.tag.viewnext
                  {:description "view next" :group "tag"})
       (awful.key [ modkey ] "Escape" awful.tag.history.restore
                  {:description "go back" :group "tag"})
       (awful.key [ modkey ] "j" (fn [] (awful.client.focus.byidx 1))
                  {:description "focus next by index" :group "client"})
       (awful.key [ modkey ] "k" (fn [] (awful.client.focus.byidx -1))
                  {:description "focus previous by index" :group "client"})

       ;; Layout manipulation
       (awful.key [ modkey shift ] "j" (fn [] (awful.client.swap.byidx 1))
                  {:description "swap with next client by index" :group "client"})
       (awful.key [ modkey shift ] "k" (fn [] (awful.client.swap.byidx -1))
                  {:description "swap with previous client by index" :group "client"})
       (awful.key [ modkey ctrl ] "j" (fn [] (awful.screen.focus_relative 1))
                  {:description "focus the next screen" :group "screen"})
       (awful.key [ modkey ctrl ] "k" (fn [] (awful.screen.focus_relative -1))
                  {:description "focus the previous screen" :group "screen"})
       (awful.key [ modkey ] "u" awful.client.urgent.jumpto
                  {:description "jump to urgent client" :group "client"})
       (awful.key [ modkey ] "Tab" (fn []
                                     (awful.client.focus.history.previous)
                                     (when client.focus (: client.focus :raise)))
                  {:description "go back" :group "client"})

       ;; Standard program
       (awful.key [ modkey ] "Return" (fn [] (awful.spawn terminal))
                  {:description "open a terminal" :group "launcher"})
       (awful.key [ modkey ctrl ] "r" awesome.restart
                  {:description "reload awesome" :group "awesome"})
       (awful.key [ modkey shift ] "q" awesome.quit
                  {:description "quit awesome" :group "awesome"})

       ;; layout
       (awful.key [ modkey ] "l" (fn [] (awful.tag.incmwfact 0.05))
                  {:description "increase master width factor" :group "layout"})
       (awful.key [ modkey ] "h" (fn [] (awful.tag.incmwfact -0.05))
                  {:description "decrease master width factor" :group "layout"})
       (awful.key [ modkey shift ] "h" (fn [] (awful.tag.incnmaster 1 nil true))
                  {:description "increase the number of master clients" :group "layout"})
       (awful.key [ modkey shift ] "l" (fn [] (awful.tag.incnmaster -1 nil true))
                  {:description "decrease the number of master clients" :group "layout"})
       (awful.key [ modkey ctrl ] "h" (fn [] (awful.tag.incncol 1 nil true))
                  {:description "increase the number of columns" :group "layout"})
       (awful.key [ modkey ctrl ] "l" (fn [] (awful.tag.incncol -1 nil true))
                  {:description "decrease the number of columns" :group "layout"})
       (awful.key [ modkey ] "space" (fn [] (awful.layout.inc 1))
                  {:description "select next" :group "layout"})
       (awful.key [ modkey shift ] "space" (fn [] (awful.layout.inc -1))
                  {:description "select previous" :group "layout"})
       (awful.key [ modkey ctrl ] "n" (fn []
                                             (local c (awful.client.restore))
                                             (when c ;; Focus restored client
                                               (: c :emit_signal "request::activate" "key.unminimize" {:raise true})))
                  {:description "restore minimized" :group "client"})

       ;; Prompt
       (awful.key [ modkey ] "r" (fn [] (: (. (awful.screen.focused) :mypromptbox) :run))
                  {:description "run prompt" :group "launcher"})

       (awful.key [ modkey ] "x" (fn []
                                   (let [fscr (awful.screen.focused)]
                                     (awful.prompt.run {
                                                        :prompt       "Run Lua code: "
                                                        :textbox      fscr.mypromptbox.widget
                                                        :exe_callback awful.util.eval
                                                        :history_path (.. (awful.util.get_cache_dir) "/history_eval")
                                                        })))
                  {:description "lua execute prompt" :group "awesome"})

       ;; Menubar
       ;; (awful.key [ modkey ] "p" (fn [] (menubar.show))
       ;;            {:description "show the menubar" :group "launcher"})

       ;; ;; Programs
       ;; (awful.key [modkey] "d" (awful.spawn "emacsclient -c -e '(dired-jump)'")
       ;;            {:description "launch dired in new emacs frame" :group "apps" })
       ;; ;; rofi
       ;; (awful.key [] "Menu" (awful.spawn "/home/chris/.dotfiles/rofi/launchers-git/launcher.sh")
       ;;            {:description "launch rofi" :group "launcher"})
       ))

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

;; Bind all key numbers to tags.
;; Be careful: we use keycodes to make it work on any keyboard layout.
;; This should map on the top row of your keyboard, usually 1 to 9.
(for [i 1 9]
  (global globalkeys
          (gears.table.join
           globalkeys
           ;; View tag only.
           (awful.key [ modkey ] (.. "#" (+ i 9))
                      (fn []
                        (let [screen (awful.screen.focused)
                              tag    (. screen.tags i)]
                          (when tag
                            (: tag :view_only))))
                      {:description (.. "view tag #" i) :group "tag"})
           ;; Toggle tag display
           (awful.key [ modkey ctrl ] (.. "#" (+ i 9))
                      (fn []
                        (let [screen (awful.screen.focused)
                              tag    (. screen.tags i)]
                          (when tag
                            (awful.tag.viewtoggle))))
                      {:description (.. "toggle tag #" i) :group "tag"})
           ;; Move client to tag
           (awful.key [ modkey shift ] (.. "#"  (+ i 9))
                      (fn []
                        (when client.focus
                          (let [tag (. client.focus.screen.tags i)]
                            (when tag
                              (: client.focus :move_to_tag tag)))))
                      {:description (.. "move focused client to tag #" i) :group "tag"})
           ;; Toggle tag on focused client.
           (awful.key [ modkey ctrl shift ] (.. "#" (+ i 9))
                      (fn []
                        (when client.focus
                          (let [tag (. client.focus.screen.tags i)]
                            (when tag
                              (: client.focus :toggle_tag tag)))))
                      {:description (.. "toggle focused client on tag #" i) :group "tag"}))))

globalkeys
