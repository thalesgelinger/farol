local socket = require("socket")

local Farol = {
    routes = {}
}
Farol.__index = Farol

function Farol:new()
    local farol = setmetatable({}, Farol)
    return farol
end

function Farol:resource(controllerPath)
    local controller = require(controllerPath)
    return function(config)
        if controller["index"] then
            self.routes["GET " .. config.path] = controller["index"]
        end
    end
end

function Farol:listen(port)
    local server = assert(socket.bind("*", tonumber(port)), "Failed to init server on port " .. port)
    print("Server running on http://localhost:" .. port)

    local http = require "server.http"

    while true do
        local client = server:accept()
        client:settimeout(1)

        local request, err = client:receive()
        local method, path = request:match("^(%w+)%s+(%S+)")
        print(method, path)

        if self.routes[method .. " " .. path] then
            local response = self.routes[method .. " " .. path]()
            http:body(response)
            client:send(http:build())
        end

        client:close()
    end
end

return Farol
