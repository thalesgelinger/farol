-- DEV ONLY
package.path = package.path .. ";../?.lua"     -- For individual Lua files
package.path = package.path .. ";./?.lua"      -- For individual Lua files
package.path = package.path .. ";./?/init.lua" -- For directories containing an init.lua

local app = require "core.router"

app:listen(3000)
