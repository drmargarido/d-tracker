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
    use_db(function(db, name)
        local query_stmt
        if #name > 0 then
            local query = [[
                SELECT name
                FROM project as p
                LEFT JOIN task t ON p.id = t.project_id
                WHERE name LIKE ?
                GROUP BY name HAVING max(t.start_time) OR t.start_time is NULL
                ORDER BY t.start_time DESC
                LIMIT 7
            ]]
            query_stmt = db:prepare(query)
            query_stmt:bind_values("%"..name.."%")
        else
            local query = [[
                SELECT name
                FROM project as p
                LEFT JOIN task t ON p.id = t.project_id
                GROUP BY name HAVING max(t.start_time) OR t.start_time is NULL
                ORDER BY t.start_time DESC
                LIMIT 7
            ]]
            query_stmt = db:prepare(query)
        end

        local tasks = {}
        for row in query_stmt:nrows() do
            table.insert(tasks, row.name)
        end

        return tasks, nil
    end)
)
