local socket = require("socket")

local Farol = {
    routes = {
        ["GET/favicon.ico"] = function()
            return {
                type = "image",
                image = "\0\0\1\0\1\0\10\10\20\0\0\0\0\0\40\0\0\0\22\0\0\0\1\0\4\0"
            }
        end
    }
}

Farol.__index = Farol

function Farol:new()
    local farol = setmetatable({}, Farol)
    return farol
end

function Farol:get(path, fn)
    self.routes["GET" .. path] = fn
end

function Farol:resource(controllerPath)
    local controller = require(controllerPath)
    return function(config)
        if controller["index"] then
            self.routes["GET" .. config.path] = controller["index"]
        end

        if controller["new"] then
            self.routes["GET" .. config.path .. "/new"] = controller["new"]
        end

        if controller["show"] then
            self.routes["GET" .. config.path .. "/:id"] = controller["show"]
        end

        if controller["edit"] then
            self.routes["GET" .. config.path .. "/:id/edit"] = controller["edit"]
        end
    end
end

--- @param method "GET" | "POST"
--- @param path string
--- @return function
--- @return table
function Farol:match_route(method, path)
    if self.routes[method .. path] then
        return self.routes[method .. path], {}
    end

    -- Function to split a string into parts based on "/"
    local function splitPath(path)
        local parts = {}
        for part in string.gmatch(path, "[^/]+") do
            table.insert(parts, part)
        end
        return parts
    end

    -- Preprocess routes into a list for easier matching
    local function preprocessRoutes(routes)
        local routeList = {}
        for route, value in pairs(routes) do
            local parts = splitPath(route)
            table.insert(routeList, { parts = parts, value = value })
        end
        -- Sort routes by specificity: static segments > dynamic parameters
        table.sort(routeList, function(a, b)
            local function countStatic(parts)
                local count = 0
                for _, part in ipairs(parts) do
                    if not part:match("^:") then
                        count = count + 1
                    end
                end
                return count
            end
            return countStatic(a.parts) > countStatic(b.parts)
        end)
        return routeList
    end

    -- Match an incoming path against the routes
    local function matchPath(p, routeList)
        local pathParts = splitPath(p)

        for _, route in ipairs(routeList) do
            local routeParts = route.parts
            if #routeParts == #pathParts then
                local isMatch = true
                local params = {}
                for i = 1, #routeParts do
                    if routeParts[i]:sub(1, 1) == ":" then
                        -- It's a dynamic parameter
                        local paramName = routeParts[i]:sub(2) -- Remove leading ":"
                        params[paramName] = pathParts[i]
                    elseif routeParts[i] ~= pathParts[i] then
                        -- Static part does not match
                        isMatch = false
                        break
                    end
                end

                if isMatch then
                    return route.value, params
                end
            end
        end
        return nil, nil -- No match found
    end

    local processedRoutes = preprocessRoutes(self.routes)

    local matched_fn, params = matchPath(method .. path, processedRoutes)

    if matched_fn then
        return function(p)
            return matched_fn(self, p) -- Ensure `self` is passed
        end, params
    end

    return nil, nil
end

function Farol:listen(port)
    local server = assert(socket.bind("*", tonumber(port)), "Failed to init server on port " .. port)
    print("Server running on http://localhost:" .. port)

    local http = require "server.http"

    while true do
        local client = server:accept()
        client:settimeout(1)

        local request, err = client:receive()

        if err then
            print("[ERROR] " .. err)
        end

        if request then
            local method, path = request:match("^(%w+)%s+(%S+)")

            print(method, path)

            local matched_route, params = self:match_route(method, path)

            if matched_route then
                local response = matched_route(params)
                http:body(response)
                client:send(http:build())
            else
                http:body("404 Not Found")
                client:send(http:build())
            end
        end

        client:close()
    end
end

return Farol
