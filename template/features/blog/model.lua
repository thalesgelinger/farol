local Model = require "db.model".Model
local t = require "db.model".Types

local Blog = Model:new {
    title = t.string,
    body = t.text
}

return Blog
