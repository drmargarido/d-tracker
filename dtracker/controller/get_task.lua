-- Utils
local validators = require "dtracker.validators.base_validators"
local db_validators = require "dtracker.validators.db_validators"

-- Decorators
local decorators = require "dtracker.decorators"
local use_db = decorators.use_db
local check_input = decorators.check_input

return check_input(
    {
        {validators.is_number, db_validators.task_exists}
    },
    use_db(function(db, task_id)
        local task_query = string.format([[
            SELECT p.name as project, t.id, t.start_time, t.end_time, t.description
            FROM task as t
            LEFT JOIN project p ON p.id = t.project_id
            WHERE t.id=%d
        ]], task_id)

        for t in db:nrows(task_query) do
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
