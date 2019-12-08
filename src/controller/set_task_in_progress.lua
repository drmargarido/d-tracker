-- Controllers
local stop_task = require "src.controller.stop_task"

-- Decorators
local decorators = require "src.decorators"

return decorators.use_db(function(db, task_id)
    stop_task()

    local project_edit = "UPDATE task SET end_time=NULL WHERE id=?"
    local project_stmt = db:prepare(project_edit)
    project_stmt:bind_values(task_id)
    project_stmt:step()

    return true, nil
end)
