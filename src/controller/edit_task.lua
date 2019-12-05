local sqlite3 = require "lsqlite3"
local conf = require "src.conf"

local project_exists = require "src.controller.project_exists"
local create_project = require "src.controller.create_project"

return function(task_id, field, new_value)
    local db = sqlite3.open(conf.db)

    if field == "project" then
        if not project_exists(new_value) then
            create_project(new_value)
        end

        local project_edit = [[
            UPDATE task
            SET project_id=(SELECT id FROM project WHERE name=?)
            WHERE id=?
        ]]
        local project_stmt = db:prepare(project_edit)
        project_stmt:bind_values(
            new_value,
            task_id
        )
        project_stmt:step()
    elseif field == "start_time" then
        local start_edit = [[
            UPDATE task SET start_time=? WHERE id=?
        ]]
        local start_stmt = db:prepare(start_edit)
        start_stmt:bind_values(
            new_value:fmt("${iso}"),
            task_id
        )
        start_stmt:step()

    elseif field == "end_time" then
        local end_edit = [[
            UPDATE task SET end_time=? WHERE id=?
        ]]
        local end_stmt = db:prepare(end_edit)
        end_stmt:bind_values(
            new_value:fmt("${iso}"),
            task_id
        )
        end_stmt:step()

    elseif field == "description" then
        local end_edit = [[
            UPDATE task SET description=? WHERE id=?
        ]]
        local end_stmt = db:prepare(end_edit)
        end_stmt:bind_values(
            new_value,
            task_id
        )
        end_stmt:step()
    else
        print("Unknown field for task edit")
        return false
    end

    db:close()
    return true
end
