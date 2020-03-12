-- Utils
local date = require "date.date"

-- validators
local validators = require "src.validators.base_validators"
local db_validators = require "src.validators.db_validators"

-- Decorators
local decorators = require "src.decorators"
local use_db = decorators.use_db
local check_input = decorators.check_input

-- Plugins
local event_manager = require "src.plugin_manager.event_manager"
local events = require "src.plugin_manager.events"

-- Controllers
local stop_task = require "src.controller.stop_task"
local create_project = require "src.controller.create_project"

return check_input(
    {
        {validators.is_text, validators.max_length(512), validators.min_length(1)},
        {validators.is_text, validators.max_length(255), validators.min_length(1)},
    },
    use_db(function(db, description, project)
        -- Create a new project if it doesn't exists
        local project_exists, _ = db_validators.project_exists(project)
        if not project_exists then
            local _, err = create_project(project)
            if err ~= nil then
                return false, "Failed to stop the running task"
            end
        end

        -- If there is any task already running stop it
        local _, err = stop_task()
        if err ~= nil then
            return false, "Failed to stop the running task"
        end

        -- Create a new task starting at the current moment
        local sql_create = [[
            INSERT INTO task (project_id, start_time, description)
            VALUES ((SELECT id FROM project WHERE name=?), ?, ?)
        ]]
        local task_stmt = db:prepare(sql_create)
        local current_date = date():fmt("${iso}")
        task_stmt:bind_values(
            project,
            current_date,
            description
        )
        task_stmt:step()
        if not db_validators.operation_ok(db) then
            return false, "Failed to create the new task"
        end

        event_manager.fire_event(events.TASK_CREATED, {
            description=description,
            project=project,
            date=current_date
        })

        return true, nil
    end)
)
