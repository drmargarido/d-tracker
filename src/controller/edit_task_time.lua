-- Validators
local validators = require "src.validators.base_validators"
local db_validators = require "src.validators.db_validators"

-- Decorators
local decorators = require "src.decorators"
local use_db = decorators.use_db
local check_input = decorators.check_input

-- Controllers
local list_tasks = require "src.controller.list_tasks"

return check_input(
    {
        {
            validators.is_number,
            db_validators.task_exists
        },
        {validators.is_date},
        {validators.is_date}
    },
    use_db(function(db, task_id, start_time, end_time)
        if start_time > end_time then
            return false, "The start time of a task must be before the end time!"
        end

        local tasks = list_tasks(start_time, end_time)
        for _, task in ipairs(tasks) do
            if task.id ~= task_id then
                local description = task.description
                return false, "The defined date range overlaps with the task - '"..description.."'"
            end
        end

        local start_edit = [[
            UPDATE task SET start_time=?, end_time=? WHERE id=?
        ]]
        local start_stmt = db:prepare(start_edit)
        start_stmt:bind_values(
            start_time:fmt("${iso}"),
            end_time:fmt("${iso}"),
            task_id
        )
        start_stmt:step()
        if not db_validators.operation_ok(db) then
            return false, "Failed to edit the time of the task"
        end

        return true, nil
    end)
)
