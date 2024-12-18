local Http = {
    status = "200 OK\r\n",
    body = ""
}

Http.__index = Http

function Http:body(content)
    self.body = content
end

function Http:build()
    return "HTTP/1.1 " .. self.status
        .. "Content-Type: text/html; charset=UTF-8\r\n"
        .. "Content-Length: " .. #self.body .. "\r\n"
        .. "\r\n"
        .. self.body
end

return Http
