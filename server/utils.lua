local function escape_string(str)
    local replacements = {
        ["\\"] = "\\\\",
        ["\""] = "\\\"",
        ["\b"] = "\\b",
        ["\f"] = "\\f",
        ["\n"] = "\\n",
        ["\r"] = "\\r",
        ["\t"] = "\\t",
    }
    return str:gsub("[%z\1-\31\"\\]", replacements)
end

function table.stringify(tbl)
    local function serialize(value)
        if type(value) == "table" then
            -- Check if the table is an array or an object
            local is_array = #value > 0
            local result = {}

            if is_array then
                for i, v in ipairs(value) do
                    table.insert(result, serialize(v))
                end
                return "[" .. table.concat(result, ",") .. "]"
            else
                for k, v in pairs(value) do
                    if type(k) ~= "string" then
                        error("JSON object keys must be strings")
                    end
                    table.insert(result, "\"" .. escape_string(k) .. "\":" .. serialize(v))
                end
                return "{" .. table.concat(result, ",") .. "}"
            end
        elseif type(value) == "string" then
            return "\"" .. escape_string(value) .. "\""
        elseif type(value) == "number" or type(value) == "boolean" then
            return tostring(value)
        elseif value == nil then
            return "null"
        else
            error("Unsupported data type: " .. type(value))
        end
    end

    return serialize(tbl)
end


