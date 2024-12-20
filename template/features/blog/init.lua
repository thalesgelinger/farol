Blog = require "features.blog.model"
local template = require "server.render".template

local BlogController = {}
BlogController.__index = BlogController

-- GET /blogs
function BlogController:index()
    return Blog.all()
end

-- GET /blogs/:id
--- @param req table
function BlogController:show(req)
    return Blog.find_by({ id = req.params.id })
end

-- GET /blogs/new html form for new resource
function BlogController:new()
    self.title = "My Page"
    self.user = "John"
    self.items = { "Apple", "Banana", "Cherry" }

    return template("features/blog/view.elua", self)
end

-- POST /blogs
function BlogController:create(req)
    Blog.create(req.body)
end

-- GET /blogs/:id/edit html form for edit resource
function BlogController:edit(req)
    return "<h1> Soon we will have an edit page here " .. req.params.id .. " </h1>"
end

-- PATCH/PUT /blogs
function BlogController:update(req)
    Blog.update(req.body)
end

-- DELETE /blogs/:id
function BlogController:destroy(req)
    Blog.destroy(req.params.id)
end

return BlogController
