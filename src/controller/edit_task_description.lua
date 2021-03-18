-- Validators
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
            db_validators.task_exists
        },
        {
            validators.is_text,
            validators.min_length(1),
            validators.max_length(512)
        }
    },
    use_events(use_db(function(db, events_queue, task_id, new_value)
        local end_edit = [[
            UPDATE task SET description=? WHERE id=?
        ]]
        local end_stmt = db:prepare(end_edit)
        end_stmt:bind_values(
            new_value,
            task_id
        )
        end_stmt:step()

        local success, _ = db_validators.operation_ok(db)
        end_stmt:finalize()

        if not success then
            return false, "Failed to edit the task description"
        end

        table.insert(events_queue, {
            id=events.TASK_EDIT,
            data={id=task_id, description=new_value}
        })
        return true, nil
    end))
)
