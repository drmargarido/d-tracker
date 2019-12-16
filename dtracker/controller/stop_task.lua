-- Validators
local db_validators = require "dtracker.validators.db_validators"

-- Utils
local date = require "date.date"

-- Decorators
local decorators = require "dtracker.decorators"
local use_db = decorators.use_db

return use_db(function(db)
    local stop_query = string.format(
        "UPDATE task SET end_time='%s' WHERE end_time IS NULL",
        date():fmt("${iso}")
    )

    db:exec(stop_query)
    if not db_validators.operation_ok(db) then
        return false, "Failed to stop the running task"
    end

    return true, nil
end)
