-- TODO: only in dev
package.path = "/Users/tgelin01/Projects/farol/?.lua;" .. package.path

local Farol = require "server.farol"

local app = Farol:new()


app:resource "features.blog" {
    path = "/blogs",
    -- The idea here is to create sub resources
    -- app:resource "features.blog.comment" { path = "/comments" }
}

return app
