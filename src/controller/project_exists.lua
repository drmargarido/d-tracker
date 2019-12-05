local sqlite3 = require "lsqlite3"
local conf = require "src.conf"

return function(project_name)
    local db = sqlite3.open(conf.db)

    local sql_check = "SELECT * FROM project WHERE name=?"
    local check_stmt = db:prepare(sql_check)
    check_stmt:bind_values(project_name)

    local project_exists = false
    for _ in check_stmt:nrows() do
        project_exists = true
    end

    db:close()
    return project_exists
end
