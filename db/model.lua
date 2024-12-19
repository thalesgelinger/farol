local Model = {}

-- FIXME: Keep in memory just for testing now
local data = {}

function Model:new(model)
    for key, value in pairs(model) do
        print("key: ", key, "value: ", value)
    end

    function model.all()
        return data
    end

    function model.find() end

    function model.find_by(param)
        for k, _ in pairs(param) do
            for _, v in ipairs(data) do
                if tonumber(v[k]) == tonumber(param[k]) then
                    return v
                end
            end
        end
        return nil
    end

    function model.where() end

    function model.new() end

    function model.create(new)
        new.id = #data + 1
        table.insert(data, new)
    end

    function model.update(new)
        local index = -1
        for i, value in ipairs(data) do
            if value.id == new.id then
                index = i
            end
        end

        if index > 0 then
            data[index] = new
        end
    end

    function model.destroy(id)
        local index = -1
        for i, value in ipairs(data) do
            if tonumber(value.id) == tonumber(id) then
                index = i
                break
            end
        end

        if index > 0 then
            table.remove(data, index)
        end
    end

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
