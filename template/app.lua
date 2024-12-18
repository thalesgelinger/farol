local Farol = require "server.farol"

local app = Farol:new()

app:get("/", function()
    return "<h1>Hello World</h1>"
end)

app:listen(3000)
