-- Decorators
local decorators = require "src.decorators"
local use_db = decorators.use_db

return use_db(function(db)
    local projects = {}
    for row in db:nrows("SELECT * FROM project") do
        table.insert(projects, {
            id=row.id,
            name=row.name
        })
    end

    return projects
end)
