-- Decorators
local decorators = require "src.decorators"

-- Create a new project without validating if it already exists
return decorators.use_db(function(db, project_name)
    local sql_project = "INSERT INTO project (name) VALUES (?)"
    local project_stmt = db:prepare(sql_project)
    project_stmt:bind_values(project_name)
    project_stmt:step()

    return true, nil
end)
