-- Controllers
local stop_task = require "src.controller.stop_task"

-- Validators
local validators = require "src.validators.base_validators"
local db_validators = require "src.validators.db_validators"

-- Decorators
local decorators = require "src.decorators"
local use_db = decorators.use_db
local check_input = decorators.check_input

return check_input(
    {
        {validators.is_number, validators.is_positive, db_validators.task_exists}
    },
    use_db(function(db, task_id)
        local _,err = stop_task()
        if err ~= nil then
            return false, "Failed to stop the running task to set the task in progress"
        end

        local project_edit = "UPDATE task SET end_time=NULL WHERE id=?"
        local project_stmt = db:prepare(project_edit)
        project_stmt:bind_values(task_id)
        project_stmt:step()

        local success, _ = db_validators.operation_ok(db)
        project_stmt:finalize()

        if not success then
            return false, "Failed to set the the task in progress"
        end

        return true, nil
    end)
)
