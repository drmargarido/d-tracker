-- Utils
local validators = require "src.validators.base_validators"
local db_validators = require "src.validators.db_validators"

-- Plugins
local events = require "src.plugin_manager.events"

-- Decorators
local decorators = require "src.decorators"
local use_db = decorators.use_db
local check_input = decorators.check_input
local use_events = decorators.use_events

-- Create a new project without validating if it already exists
return check_input(
    {
        {validators.is_text, validators.max_length(255)}
    },
    use_events(use_db(function(db, events_queue, project_name)
        local sql_project = "INSERT INTO project (name) VALUES (?)"
        local project_stmt = db:prepare(sql_project)
        project_stmt:bind_values(project_name)
        project_stmt:step()

        local success, _ = db_validators.operation_ok(db)
        project_stmt:finalize()
        if not success then
            return false, "Failed to create the new project"
        end

        table.insert(events_queue, {
            id=events.PROJECT_CREATED,
            data={name=project_name}
        })
        return true, nil
    end))
)
