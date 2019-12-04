local sqlite3 = require "lsqlite3"
local conf = require "src.conf"
local date = require "date.date"

local stop_task = require "src.controller.stop_task"

return function(description, project)
    local db = sqlite3.open(conf.db)
    -- Check if the project already exists
    local sql_check = "SELECT * FROM project WHERE name=?"
    local check_stmt = db:prepare(sql_check)
    check_stmt:bind_values(project)

    local project_exists = false
    for _ in check_stmt:nrows() do
        project_exists = true
    end

    -- Create a new project if it doesn't exists
    if not project_exists then
        local sql_project = "INSERT INTO project (name) VALUES (?)"
        local project_stmt = db:prepare(sql_project)
        project_stmt:bind_values(project)
        project_stmt:step()
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

    db:close()
    return true
end
