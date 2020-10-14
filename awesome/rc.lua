pcall(require, "luarocks.loader")
fennel = require("fennel")
local gears = require("gears")
fennel.path = fennel.path .. ";.config/awesome/?.fnl"
table.insert(package.loaders or package.searchers, fennel.make_searcher({correlate=true}))

require("init") -- load ~/.config/awesome/config.fnl
