local date = require "date.date"

-- Decorators
local decorators = require "src.decorators"

-- Controllers
local stop_task = require "src.controller.stop_task"
local project_exists = require "src.controller.project_exists"
local create_project = require "src.controller.create_project"

return decorators.use_db(function(db, description, project)
    -- Create a new project if it doesn't exists
    if not project_exists(project) then
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
