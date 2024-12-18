local Model = {}

function Model:new(model)
    for key, value in pairs(model) do
        print("key: ", key, "value: ", value)
    end

    function model.all()
        return {
            this = "example"
        }
    end

    return model
end

local Types = {
    string = "string",
    text = "text",
}

return Model, Types
