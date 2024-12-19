local function render_template(template, context)
    local output = {}
    local env = setmetatable({}, { __index = context })

    -- Replace `<@= expression @>` with Lua code that appends the result to `output`
    template = template:gsub("<@=(.-)@>", function(code)
        print("CODE: ", code)
        return code
    end)

    print(template)

    -- Replace `<@ ... @>` with the Lua code itself
    template = template:gsub("<@(.-)@>", function(code)
        return code
    end)

    print(template)

    -- Wrap the transformed template in Lua code to execute
    local lua_code = string.format([[
        local output = ...
        %s
        return table.concat(output)
    ]], template)

    -- Compile the Lua code
    local func, err = load(lua_code, "template", "t", env)
    if not func then
        error("Template compilation error: " .. err)
    end

    -- Execute the compiled Lua code
    local success, result = pcall(func, output)
    if not success then
        error("Template execution error: " .. result)
    end

    return result
end

-- Example usage
local template = [[
<html>
<head>
    <title><@= title @></title>
</head>
<body>
    <h1>Hello, <@= user @>!</h1>
    <ul>
        <@ for i, item in ipairs(items) do @>
            <li><@= i .. ": " .. item @></li>
        <@ end @>
    </ul>
</body>
</html>
]]

-- Context table
local context = {
    title = "Welcome Page",
    user = "John Doe",
    items = { "Item 1", "Item 2", "Item 3" },
}

-- Render template
local output = render_template(template, context)
print(output)
