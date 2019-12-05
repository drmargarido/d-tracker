local sqlite3 = require "lsqlite3"
local conf = require "src.conf"

-- Create a new project without validating if it already exists
return function(project_name)
    local db = sqlite3.open(conf.db)

    local sql_project = "INSERT INTO project (name) VALUES (?)"
    local project_stmt = db:prepare(sql_project)
    project_stmt:bind_values(project_name)
    project_stmt:step()

    db:close()
end
