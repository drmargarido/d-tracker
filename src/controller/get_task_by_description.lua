-- Utils
local validators = require "src.validators.base_validators"

-- Decorators
local decorators = require "src.decorators"
local use_db = decorators.use_db
local check_input = decorators.check_input

return check_input(
    {
        {validators.is_text}
    },
    use_db(function(db, description)
        local task_query = string.format([[
            SELECT p.name as project, t.id, t.start_time, t.end_time, t.description
            FROM task as t
            LEFT JOIN project p ON p.id = t.project_id
            WHERE t.description=?
        ]])
        local task_stmt = db:prepare(task_query)
        task_stmt:bind_values(description)

        for t in task_stmt:nrows() do
            return {
                id=t.id,
                project=t.project,
                start_time=t.start_time,
                end_time=t.end_time,
                description=t.description
            }, nil
        end

        return nil, "Wanted task not found"
    end)
)
