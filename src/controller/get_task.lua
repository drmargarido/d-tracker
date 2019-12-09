-- Utils
local validators = require "src.validators"

-- Decorators
local decorators = require "src.decorators"
local use_db = decorators.use_db
local check_input = decorators.check_input

return check_input(
    {
        {validators.is_number}
    },
    use_db(function(db, task_id)
        local task_query = string.format([[
            SELECT p.name as project, t.id, t.start_time, t.end_time, t.description
            FROM task as t
            LEFT JOIN project p ON p.id = t.project_id
            WHERE t.id=%d
        ]], task_id)

        local task = nil
        for t in db:nrows(task_query) do
            task = {
                id=t.id,
                project=t.project,
                start_time=t.start_time,
                end_time=t.end_time,
                description=t.description
            }
            break
        end

        return task, nil
    end)
)
