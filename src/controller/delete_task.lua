local sqlite3 = require "lsqlite3"
local conf = require "src.conf"

return function(task_id)
    local db = sqlite3.open(conf.db)

    local remove_query = "DELETE FROM task WHERE id=?"
    local remove_stmt = db:prepare(remove_query)
    remove_stmt:bind_values(task_id)
    remove_stmt:step()

    db:close()
end
