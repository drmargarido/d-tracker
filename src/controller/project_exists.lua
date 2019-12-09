-- Utils
local validators = require "src.validators"

-- Decorators
local decorators = require "src.decorators"
local use_db = decorators.use_db
local check_input = decorators.check_input

return check_input(
    {
        {validators.is_text, validators.max_length(255)}
    },
    use_db(function(db, project_name)
        local sql_check = "SELECT * FROM project WHERE name=?"
        local check_stmt = db:prepare(sql_check)
        check_stmt:bind_values(project_name)

        local project_exists = false
        for _ in check_stmt:nrows() do
            project_exists = true
        end

        return project_exists, nil
    end)
)
