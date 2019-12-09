local validate = require "src.validate"
local sqlite3 = require "lsqlite3"
local conf = require "src.conf"

return {
    --[[
        Injects a new database connection in the wrapped function while
        initializing, handling errors and closing the connection
    ]]
    use_db = function(func)
        return function(...)
            local db = sqlite3.open(conf.db, sqlite3.OPEN_READWRITE)
            if not db then
                print("Failed to open database")
                return nil, "Failed to open database"
            end

            local result, err = func(db, ...)

            db:close()
            return result, err
        end
    end,

    --[[
        Checks if the received fields of the function match the
        specified table of types.
    ]]
    check_fields  = function(field_types, func)
        return function(...)
            local fields = {...}

            if #field_types ~= #fields then
                return nil, "Missing expected fields"
            end

            for i, type in ipairs(field_types) do
                local success, err = validate(type, fields[i])
                if not success then
                    print(err)
                    return nil, err
                end
            end

            return func(...)
        end
    end
}
