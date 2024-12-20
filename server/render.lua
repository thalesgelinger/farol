-- Function to parse and render the template
function renderTemplate(templatePath, context)
    local file, err = io.open(templatePath, "r")

    if not file then
        print("Error opening file:", err)
        return
    end

    local template = file:read("*a")
    -- Replace placeholders like <@= variable @> with the value from context
    local function replacePlaceholders(str)
        return str:gsub("<@=%s*(.-)%s*@>", function(key)
            -- Debug: Print the key that we are extracting
            -- Check if the key exists in context and return the value or an empty string
            return tostring(context[key]) or "undefined"
        end)
    end

    -- Function to handle loops dynamically
    local function handleLoops(str)
        return str:gsub("<@ for (.-) in (.-) do @>(.-)<@ end @>", function(loop_vars, list_expr, loop_content)
            -- Debugging

            -- Create a custom environment for evaluating the list expression
            local env = setmetatable({}, { __index = function(_, k) return context[k] or _G[k] end })

            -- Add standard functions like ipairs to the environment
            env.ipairs = ipairs
            env.pairs = pairs

            -- Extract the actual table from the list expression
            local list_name = list_expr:match("%((.-)%)")
            if not list_name or not context[list_name] then
                print("Error: List not found in context:", list_name)
                return ""
            end
            local list = context[list_name]

            if type(list) ~= "table" then
                print("Error: List is not a table:", list_name)
                return "" -- If the list is not a table, return an empty string
            end

            -- Split the loop variables (e.g., "i, item" -> { "i", "item" })
            local loop_var_names = {}
            for var in loop_vars:gmatch("([^,]+)") do
                table.insert(loop_var_names, var:match("^%s*(.-)%s*$")) -- Trim whitespace
            end

            -- Generate the loop content
            local result = ""
            for k, v in ipairs(list) do
                -- Prepare a table for the loop's scope
                local loop_scope = { [loop_var_names[1]] = k, [loop_var_names[2]] = v }

                -- Replace placeholders dynamically using the loop's scope
                local content = loop_content:gsub("<@=%s*(.-)%s*@>", function(key)
                    return tostring(loop_scope[key] or context[key] or "undefined")
                end)
                result = result .. content
            end
            return result
        end)
    end

    -- First, handle loops
    template = handleLoops(template)

    -- Then, replace placeholders
    template = replacePlaceholders(template)

    return template
end

local function getScriptDirectory()
    local info = debug.getinfo(1, "S")                -- Get the script info
    local path = info.source:match("^@(.+/)") or "./" -- Extract the directory
    return path
end

local scriptDir = getScriptDirectory()
local filePath = scriptDir .. "example.elua"
local renderedHTML = renderTemplate(filePath, {
    title = "My Page",
    user = "John",
    items = { "Apple", "Banana", "Cherry" }
})

print(renderedHTML)
