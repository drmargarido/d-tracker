-- Validators
local validators = require "src.validators.base_validators"
local db_validators = require "src.validators.db_validators"

-- Decorators
local decorators = require "src.decorators"
local use_db = decorators.use_db
local check_input = decorators.check_input

-- Utils
local date = require "date.date"

-- Controllers
local list_tasks = require "src.controller.list_tasks"

return check_input(
    {
        {
            validators.is_number,
            db_validators.task_exists
        },
        {validators.is_date},
        {}
    },
    use_db(function(db, task_id, start_time, end_time)
        if end_time ~= nil then
            if not validators.is_date(end_time) then
                return false, "The end time must be a date or nil"
            end

            if start_time > end_time then
                return false, "The start time of a task must be before the end time!"
            end
        end

        local _end_time = end_time or date()
        local tasks = list_tasks(start_time, _end_time)
        for _, task in ipairs(tasks) do
            if task.id ~= task_id then
                local task_end = date(task.end_time)
                local description = task.description

                -- Ignore collision when difference is less than one minute
                if math.abs((start_time - task_end):spanseconds()) > 60 then
                    return false, "The defined date range overlaps with the task - '"..description.."'"
                end
            end
        end

        local edit_stmt
        if end_time == nil then
            local time_edit = [[
                UPDATE task SET start_time=?, end_time=NULL WHERE id=?
            ]]
            edit_stmt = db:prepare(time_edit)
            edit_stmt:bind_values(
                start_time:fmt("${iso}"),
                task_id
            )
        else
            local time_edit = [[
                UPDATE task SET start_time=?, end_time=? WHERE id=?
            ]]
            edit_stmt = db:prepare(time_edit)
            edit_stmt:bind_values(
                start_time:fmt("${iso}"),
                end_time:fmt("${iso}"),
                task_id
            )
        end

        edit_stmt:step()
        if not db_validators.operation_ok(db) then
            return false, "Failed to edit the time of the task"
        end

        return true, nil
    end)
)
