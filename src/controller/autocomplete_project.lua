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
                SELECT name FROM project
                WHERE name LIKE ?
                LIMIT 8
            ]]
            query_stmt = db:prepare(query)
            query_stmt:bind_values("%"..name.."%")
        else
            local query = "SELECT name FROM project LIMIT 8"
            query_stmt = db:prepare(query)
        end

        local tasks = {}
        for row in query_stmt:nrows() do
            table.insert(tasks, row.name)
        end

        return tasks, nil
    end)
)
