-- Decorators
local decorators = require "src.decorators"
local use_db = decorators.use_db

return use_db(function(db)
    local task_query = [[
        SELECT p.name as project, t.id, t.start_time, t.end_time, t.description
        FROM task as t
        LEFT JOIN project p ON p.id = t.project_id
        WHERE t.end_time IS NULL
    ]]
    for task in db:nrows(task_query) do
        return {
            id=task.id,
            project=task.project,
            start_time=task.start_time,
            end_time=task.end_time,
            description=task.description
        }, nil
    end

    return nil, "There is no task in progress"
end)
