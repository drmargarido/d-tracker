-- Validators
local db_validators = require "src.validators.db_validators"

-- Utils
local date = require "date.date"

-- Plugins
local events = require "src.plugin_manager.events"

-- Decorators
local decorators = require "src.decorators"
local use_db = decorators.use_db
local use_events = decorators.use_events

return use_events(use_db(function(db, events_queue)
    local stop_query = string.format(
        "UPDATE task SET end_time='%s' WHERE end_time IS NULL",
        date():fmt("${iso}")
    )

    db:exec(stop_query)
    if not db_validators.operation_ok(db) then
        return false, "Failed to stop the running task"
    end

    table.insert(events_queue, {id=events.TASK_STOP, data={}})
    return true, nil
end))
