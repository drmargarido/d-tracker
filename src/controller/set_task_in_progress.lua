local sqlite3 = require "lsqlite3"
local conf = require "src.conf"

local stop_task = require "src.controller.stop_task"

return function(task_id)
    local db = sqlite3.open(conf.db)

    stop_task()
    local project_edit = "UPDATE task SET end_time=NULL WHERE id=?"
    local project_stmt = db:prepare(project_edit)
    project_stmt:bind_values(task_id)
    project_stmt:step()

    db:close()
end
