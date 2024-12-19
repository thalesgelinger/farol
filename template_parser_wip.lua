-- Function to parse and render the template
function renderTemplate(template, context)
    -- Replace placeholders like <@= variable @> with the value from context
    local function replacePlaceholders(str)
        return str:gsub("<@=%s*(.-)%s*@>", function(key)
            -- Debug: Print the key that we are extracting
            print("Replacing placeholder for key:", key)
            
            -- Check if the key exists in context and return the value or an empty string
            return tostring(context[key]) or "undefined"
        end)
    end

    -- Function to handle loops like <@ for i, item in ipairs(items) do @> ... <@ end @>
    local function handleLoops(str)
        return str:gsub("<@ for (.-) in ipairs%((.-)%) do @>(.-)<@ end @>", function(loop_var, list_name, loop_content)
            -- Debugging
            print("Handling loop for list:", list_name)
            print("Loop content:", loop_content)

            -- Ensure list_name exists in context and is a table
            local list = context[list_name]
            if type(list) ~= "table" then return "" end  -- If the list is not a table, return an empty string

            -- Generate the list content by looping through the list
            local result = ""
            for i, item in ipairs(list) do
                -- Replace loop content with the actual values
                local content = loop_content
                content = content:gsub("<@= i @>", tostring(i)):gsub("<@= item @>", tostring(item))
                result = result .. content
            end
            return result
        end)
    end

    -- First, replace loops
    template = handleLoops(template)

    -- Then, replace placeholders
    template = replacePlaceholders(template)

    return template
end

-- Example usage:

-- Context with dynamic data
local context = {
    title = "My Page",
    user = "John",
    items = {"Apple", "Banana", "Cherry"}
}

-- Template string with placeholders and loop
local template = [[
<html>
<head>
    <title><@= title @></title>
</head>
<body>
    <h1>Hello, <@= user @>!</h1>
    <ul>
        <@ for i, item in ipairs(items) do @>
            <li><@= i @>: <@= item @></li>
        <@ end @>
    </ul>
</body>
</html>
]]

-- Render the template with the context data
local renderedHTML = renderTemplate(template, context)

-- Print the result
print(renderedHTML)
