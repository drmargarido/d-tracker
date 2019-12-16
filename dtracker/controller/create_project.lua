-- Utils
local validators = require "dtracker.validators.base_validators"
local db_validators = require "dtracker.validators.db_validators"

-- Decorators
local decorators = require "dtracker.decorators"
local use_db = decorators.use_db
local check_input = decorators.check_input

-- Create a new project without validating if it already exists
return check_input(
    {
        {validators.is_text, validators.max_length(255)}
    },
    use_db(function(db, project_name)
        local sql_project = "INSERT INTO project (name) VALUES (?)"
        local project_stmt = db:prepare(sql_project)
        project_stmt:bind_values(project_name)
        project_stmt:step()

        if not db_validators.operation_ok(db) then
            return false, "Failed to create the new project"
        end

        return true, nil
    end)
)
