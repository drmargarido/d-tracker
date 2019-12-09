-- Utils
local date = require "date.date"

-- validators
local validators = require "src.validators"
local db_validators = require "src.db_validators"

-- Decorators
local decorators = require "src.decorators"
local use_db = decorators.use_db
local check_input = decorators.check_input

-- Controllers
local stop_task = require "src.controller.stop_task"
local create_project = require "src.controller.create_project"

return check_input(
    {
        {validators.is_text, validators.max_length(512)},
        {validators.is_text, validators.max_length(255)},
    },
    use_db(function(db, description, project)
        -- Create a new project if it doesn't exists
        local project_exists, _ = db_validators.project_exists(project)
        if not project_exists then
            create_project(project)
        end

        -- If there is any task already running stop it
        stop_task()

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

        return true, nil
    end)
)
