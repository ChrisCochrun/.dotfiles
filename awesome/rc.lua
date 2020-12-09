-- pcall(require, "luarocks.loader")
fennel = require("fennel")
local gears = require("gears")
fennel.path = fennel.path .. ";.config/awesome/?.fnl"
table.insert(package.loaders or package.searchers, fennel.searcher)

-- pcall(require, "luarocks.loader")
-- -- local fennel = require("./fennel")
-- fennel = require("./fennel")
-- local gears = require("gears")
-- fennel.path = fennel.path .. ";.config/awesome/?.fnl"
-- table.insert(package.loaders or package.searchers, fennel.make_searcher({correlate=true}))

-- local fennel = require("./fennel")
-- fennel.path = fennel.path .. ";.config/awesome/?.fnl"
-- fennel.makeSearcher({
--   correlate = true,
--   useMetadata = true
-- })
-- table.insert(package.loaders or package.searchers, fennel.searcher)

require("init") -- load ~/.config/awesome/init.fnl
