local sqlite3 = require "lsqlite3"
local conf = require "dtracker.conf"

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

            if #validations ~= #fields then
                return nil, "Missing expected fields"
            end

            for i, validation_list in ipairs(validations) do
                for _, validation in ipairs(validation_list) do
                    local success, err = validation(fields[i])

                    if not success then
                        print(err)
                        return nil, err
                    end
                end
            end

            return func(...)
        end
    end
}
