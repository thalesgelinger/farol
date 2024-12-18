local Model, t = require "db.model"

local Blog = Model:new {
    title = t.string,
    body = t.text
}

return Blog
