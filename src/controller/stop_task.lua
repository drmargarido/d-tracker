-- Validators
local db_validators = require "src.validators.db_validators"

-- Utils
local date = require "date.date"

-- Plugins
local event_manager = require "src.plugin_manager.event_manager"
local events = require "src.plugin_manager.events"

-- Decorators
local decorators = require "src.decorators"
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

    event_manager.fire_event(events.TASK_STOP, {})
    return true, nil
end)
