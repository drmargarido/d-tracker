local sqlite3 = require "lsqlite3"
local utils = require "src.utils"
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
        Checks if the received fields of the function pass the
        validations for each of them.
    ]]
    check_input  = function(validations, func)
        return function(...)
            local fields = {...}

            for i, validation_list in ipairs(validations) do
                local success, err = utils.validate(validation_list, fields[i])
                if not success then
                    print(err)
                    return nil, err
                end
            end

            return func(...)
        end
    end
}
