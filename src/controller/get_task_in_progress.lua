local sqlite3 = require "lsqlite3"
local conf = require "src.conf"

return function()
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
end
