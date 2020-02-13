-- Utils
local validators = require "src.validators.base_validators"
local db_validators = require "src.validators.db_validators"

-- Plugins
local event_manager = require "src.plugin_manager.event_manager"
local events = require "src.plugin_manager.events"

-- Decorators
local decorators = require "src.decorators"
local use_db = decorators.use_db
local check_input = decorators.check_input

return check_input(
    {
        {
            validators.is_number,
            validators.is_positive,
            db_validators.task_exists
        }
    },
    use_db(function(db, task_id)
        local remove_query = "DELETE FROM task WHERE id=?"
        local remove_stmt = db:prepare(remove_query)
        remove_stmt:bind_values(task_id)
        remove_stmt:step()

        if not db_validators.operation_ok(db) then
            return false, "Failed to delete the task"
        end

        event_manager.fire_event(events.TASK_DELETE, {id=task_id})
        return true, nil
    end)
)
