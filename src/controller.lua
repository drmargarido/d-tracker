local sqlite3 = require "lsqlite3"
local conf = require "src.conf"

local date = require "date.date"

local _list_tasks = function(start_date, end_date)
    local tasks = {}

    -- To include the end_date one day is added
    end_date:adddays(1)

    local db = sqlite3.open(conf.db)
    local query = string.format([[
        SELECT p.name as project, t.id, t.start_time, t.end_time, t.description
        FROM task as t
        LEFT JOIN project p ON p.id = t.project_id
        WHERE t.start_time > date('%s') AND t.start_time < date('%s')
    ]], start_date:fmt("${iso}"), end_date:fmt("${iso}"))

    for row in db:nrows(query) do
        table.insert(tasks, {
            id=row.id,
            project=row.project,
            start_time=row.start_time,
            end_time=row.end_time,
            description=row.description
        })
   end

    db:close()
    return tasks
end

local _stop_task = function()
    local db = sqlite3.open(conf.db)

    local stop_query = string.format(
        "UPDATE task SET end_time='%s' WHERE end_time IS NULL",
        date():fmt("${iso}")
    )

    db:exec(stop_query)
    db:close()
end

return {
    autocomplete_task = function(description)
        return {}
    end,
    stop_task = _stop_task,
    add_task = function(description, project)
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
        _stop_task()

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
    end,
    edit_task = function(task_id, field, new_value)
    end,
    delete_task = function(task_id)
    end,
    get_task_in_progress = function()
        local db = sqlite3.open(conf.db)
        local task_in_progress = nil

        local task_query = [[
            SELECT p.name as project, t.id, t.start_time, t.end_time, t.description
            FROM task as t
            LEFT JOIN project p ON p.id = t.project_id
            WHERE t.end_time IS NULL
        ]]
        for task in db:nrows(task_query) do
            task_in_progress = {
                id=task.id,
                project=task.project,
                start_time=task.start_time,
                end_time=task.end_time,
                description=task.description
            }
            break
        end

        db:close()
        return task_in_progress
    end,
    get_task = function(task_id)
        return {
            id=1,
            project="D-Tracker",
            start_time="2019-11-17T11:09:25",
            end_time="2019-11-17T12:09:25",
            description="Creating build setup"
        }
    end,
    list_today_tasks = function()
        local now = date()
        local today = date(now:getyear(), now:getmonth(), now:getday(), 0, 0, 0)
        return _list_tasks(today, date(today))
    end,
    list_tasks = _list_tasks
}
