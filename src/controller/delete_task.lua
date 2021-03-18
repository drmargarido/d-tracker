-- Utils
local validators = require "src.validators.base_validators"
local db_validators = require "src.validators.db_validators"

-- Plugins
local events = require "src.plugin_manager.events"

-- Decorators
local decorators = require "src.decorators"
local use_db = decorators.use_db
local check_input = decorators.check_input
local use_events = decorators.use_events

return check_input(
    {
        {
            validators.is_number,
            validators.is_positive,
            db_validators.task_exists
        }
    },
    use_events(use_db(function(db, events_queue, task_id)
        local remove_query = "DELETE FROM task WHERE id=?"
        local remove_stmt = db:prepare(remove_query)
        remove_stmt:bind_values(task_id)
        remove_stmt:step()

        local success, _ = db_validators.operation_ok(db)
        remove_stmt:finalize()

        if not success  then
            return false, "Failed to delete the task"
        end

        table.insert(events_queue, {id=events.TASK_DELETE, data={id=task_id}})
        return true, nil
    end))
)
