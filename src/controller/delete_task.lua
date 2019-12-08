-- Decorators
local decorators = require "src.decorators"

return decorators.use_db(function(db, task_id)
    local remove_query = "DELETE FROM task WHERE id=?"
    local remove_stmt = db:prepare(remove_query)
    remove_stmt:bind_values(task_id)
    remove_stmt:step()
end)
