local socket = require("socket")

local Farol = {
    routes = {}
}
Farol.__index = Farol

function Farol:new()
    local farol = setmetatable({}, Farol)
    return farol
end

function Farol:get(path, fn)
    self.routes["GET " .. path] = fn
end

function Farol:listen(port)
    local server = assert(socket.bind("*", tonumber(port)), "Failed to init server on port " .. port)
    print("Server running on http://localhost:" .. port)
    local http = require "server.http"

    while true do
        local client = server:accept()
        client:settimeout(1)

        local request, err = client:receive()
        print(request)
        local method, path = request:match("^(%w+)%s+(%S+)")

        if self.routes[method .. " " .. path] then
            local response = self.routes[method .. " " .. path]()
            http:body(response)
            client:send(http:build())
        end
        client:close()
    end
end

return Farol
