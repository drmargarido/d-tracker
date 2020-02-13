-- Utils
local validators = require "src.validators.base_validators"
local db_validators = require "src.validators.db_validators"

-- Plugins
local event_manager = require "src.plugin_manager.event_manager"
local events = require "src.plugin_manager.events"

-- Decorators
local decorators = require "src.decorators"
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

        event_manager.fire_event(events.PROJECT_CREATED, {name=project_name})
        return true, nil
    end)
)
