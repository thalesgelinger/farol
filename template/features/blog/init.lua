local Blog = require "features.blog.model"

local BlogController = {}
BlogController.__index = BlogController

-- GET /blogs
function BlogController:index()
    return Blog.all()
end

-- GET /blogs/:id
--- @param params table
function BlogController:show(params)
    return "This is the id: " .. params.id
end

-- GET /blogs/new html form for new resource
function BlogController:new()
    return "<h1> Soon we will have a new page here  </h1>"
end

-- POST /blogs
function BlogController:create() end

-- GET /blogs/:id/edit html form for edit resource
function BlogController:edit(params)
    return "<h1> Soon we will have an edit page here " .. params.id .. " </h1>"
end

-- PATCH/PUT /blogs
function BlogController:update() end

-- DELETE /blogs/:id
function BlogController:destroy() end

return BlogController
