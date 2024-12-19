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

    function model.find() end

    function model.find_by() end

    function model.where() end

    function model.new() end

    function model.create() end

    function model.update() end

    function model.destroy() end

    function model.valid() end

    function model.save() end

    function model.count() end

    function model.group() end

    return model
end

local Types = {
    string = "string",
    text = "text",
}

return Model, Types
