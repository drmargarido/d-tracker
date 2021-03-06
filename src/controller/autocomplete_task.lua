-- Validators
local validators = require "src.validators.base_validators"

-- Decorators
local decorators = require "src.decorators"
local use_db = decorators.use_db
local check_input = decorators.check_input

return check_input(
    {
        {validators.is_text, validators.max_length(255)}
    },
    use_db(function(db, description)
        local query_stmt
        if #description > 0 then
            local query = [[
                SELECT description FROM task
                WHERE description LIKE ?
                GROUP BY description HAVING max(start_time)
                ORDER BY start_time DESC
                LIMIT 7
            ]]
            query_stmt = db:prepare(query)
            query_stmt:bind_values("%"..description.."%")
        else
            local query = [[
                SELECT description FROM task
                GROUP BY description HAVING max(start_time)
                ORDER BY start_time DESC
                LIMIT 7
            ]]
            query_stmt = db:prepare(query)
        end

        local tasks = {}
        for row in query_stmt:nrows() do
            table.insert(tasks, row.description)
        end
        query_stmt:finalize()

        return tasks, nil
    end)
)
