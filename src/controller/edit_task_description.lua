-- Validators
local validators = require "src.validators.base_validators"
local db_validators = require "src.validators.db_validators"

-- Decorators
local decorators = require "src.decorators"
local use_db = decorators.use_db
local check_input = decorators.check_input

return check_input(
    {
        {
            validators.is_number,
            db_validators.task_exists
        },
        {
            validators.is_text,
            validators.max_length(512)
        }
    },
    use_db(function(db, task_id, new_value)
        local end_edit = [[
            UPDATE task SET description=? WHERE id=?
        ]]
        local end_stmt = db:prepare(end_edit)
        end_stmt:bind_values(
            new_value,
            task_id
        )
        end_stmt:step()
        if not db_validators.operation_ok(db) then
            return false, "Failed to edit the task description"
        end

        return true, nil
    end)
)
