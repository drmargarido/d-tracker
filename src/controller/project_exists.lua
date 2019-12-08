-- Decorators
local decorators = require "src.decorators"

return decorators.use_db(function(db, project_name)
    local sql_check = "SELECT * FROM project WHERE name=?"
    local check_stmt = db:prepare(sql_check)
    check_stmt:bind_values(project_name)

    local project_exists = false
    for _ in check_stmt:nrows() do
        project_exists = true
    end

    return project_exists, nil
end)
