local event_manager = require "src.plugin_manager.event_manager"
local sqlite3 = require "lsqlite3"
local utils = require "src.utils"
local conf = require "src.conf"


return {
    --[[
        Usually we want ot fire an event after other actions had happened, so
        instead of triggering them instantly we queue them up to be fired after
        the main code has finished.
    ]]
    use_events = function(func)
      return function(...)
        local events = {}
        local result, err = func(events, ...)
        for _, event in ipairs(events) do
            event_manager.fire_event(event.id, event.data)
        end

        return result, err
      end
    end,

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

            if db:isopen() then
              db:close()
            end
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
