-- Utils
local date = require "date.date"

-- validators
local validators = require "src.validators.base_validators"
local db_validators = require "src.validators.db_validators"

-- Decorators
local decorators = require "src.decorators"
local use_db = decorators.use_db
local check_input = decorators.check_input
local use_events = decorators.use_events

-- Plugins
local events = require "src.plugin_manager.events"

-- Controllers
local stop_task = require "src.controller.stop_task"
local create_project = require "src.controller.create_project"

return check_input(
    {
        {validators.is_text, validators.max_length(512), validators.min_length(1)},
        {validators.is_text, validators.max_length(255), validators.min_length(1)},
    },
    use_events(use_db(function(db, events_queue, description, project)
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

        local success, error = db_validators.operation_ok(db)
        task_stmt:finalize()
        if not success then
            return false, error or "Failed to create the new task"
        end

        table.insert(events_queue, {
            id=events.TASK_CREATED,
            data={
                description=description,
                project=project,
                date=current_date
            }
        })

        return true, nil
    end))
)
