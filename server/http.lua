local cjson = require "cjson"
require "server.utils"

local Http = {
    status = "200 OK\r\n",
    headers = {},
    content = ""
}

Http.__index = Http

function Http:body(content)
    if type(content) == "table" then
        if content.type == "image" then
            table.insert(self.headers, {
                ["Content-Type"] = "image/x-icon"
            })
            self.content = content.image
            return
        end

        table.insert(self.headers, {
            ["Content-Type"] = "application/json"
        })
        self.content = cjson.encode(content)
        return
    end
    table.insert(self.headers, {
        ["Content-Type"] = "text/html; charset=UTF-8"
    })
    if content then
        self.content = content
    end
end

function Http:build()
    local headers = ""

    for _, value in ipairs(self.headers) do
        for k, v in pairs(value) do
            headers = headers .. k .. ":" .. v .. "\r\n"
        end
    end

    return "HTTP/1.1 " .. self.status
        .. headers
        .. "Content-Length: " .. #self.content .. "\r\n"
        .. "\r\n"
        .. self.content
end

return Http
