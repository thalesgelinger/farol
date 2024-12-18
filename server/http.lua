require "server.utils"

local Http = {
    status = "200 OK\r\n",
    headers = {},
    body = ""
}

Http.__index = Http

function Http:body(content)
    if type(content) == "table" then
        table.insert(self.headers, {
            ["Content-Type"] = "application/json"
        })
        self.body = table.stringify(content)
        return
    end
    table.insert(self.headers, {
        ["Content-Type"] = "text/html; charset=UTF-8"
    })
    self.body = content
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
        .. "Content-Length: " .. #self.body .. "\r\n"
        .. "\r\n"
        .. self.body
end

return Http
