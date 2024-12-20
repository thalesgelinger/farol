-- TODO: only in dev

local Farol = require "server.farol"

local app = Farol:new()

app:resource "features.blog" {
    path = "/blogs",
    -- The idea here is to create sub resources
    -- app:resource "features.blog.comment" { path = "/comments" }
}

return app
