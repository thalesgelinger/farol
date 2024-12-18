local Blog = require "features.blog.model"

local BlogController = {}
BlogController.__index = BlogController

-- GET /blog
function BlogController:index()
    return Blog.all()
end

-- GET /blog/:id
function BlogController:show() end

-- GET /blog/new html form for new resource
function BlogController:new() end

-- POST /blog
function BlogController:create() end

-- GET /blog html form for edit resource
function BlogController:edit() end

-- PATCH/PUT /blog
function BlogController:update() end

-- DELETE /blog/:id
function BlogController:destroy() end

return BlogController
