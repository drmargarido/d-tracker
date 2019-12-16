-- Utils
local date = require "date.date"

-- validators
local validators = require "dtracker.validators.base_validators"
local db_validators = require "dtracker.validators.db_validators"

-- Decorators
local decorators = require "dtracker.decorators"
local use_db = decorators.use_db
local check_input = decorators.check_input

-- Controllers
local stop_task = require "dtracker.controller.stop_task"
local create_project = require "dtracker.controller.create_project"

return check_input(
    {
        {validators.is_text, validators.max_length(512)},
        {validators.is_text, validators.max_length(255)},
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
        task_stmt:bind_values(
            project,
            date():fmt("${iso}"),
            description
        )
        task_stmt:step()
        if not db_validators.operation_ok(db) then
            return false, "Failed to create the new task"
        end

        return true, nil
    end)
)
