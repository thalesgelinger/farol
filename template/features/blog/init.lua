Blog = require "features.blog.model"
local template = require "server.render".template

local BlogController = {}
BlogController.__index = BlogController

-- GET /blogs
function BlogController:index()
    self.posts = Blog.all()
    return template("features/blog/posts.elua", self)
end

-- GET /blogs/:id
--- @param req table
function BlogController:show(req)
    local post = Blog.find_by({ id = req.params.id })
    self.title = post.title
    self.body = post.body
    return template("features/blog/show.elua", self)
end

-- GET /blogs/new html form for new resource
function BlogController:new()
    return template("features/blog/new.elua", self)
end

-- POST /blogs
function BlogController:create(req)
    return Blog.create(req.body)
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
