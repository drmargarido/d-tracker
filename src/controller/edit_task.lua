local sqlite3 = require "lsqlite3"
local utils = require "src.utils"
local conf = require "src.conf"

local project_exists = require "src.controller.project_exists"
local create_project = require "src.controller.create_project"

-- Strategy to edit each field of the task
local edit_task_field = {
    project = function(db, task_id, new_value)
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
    end,

    start_time = function(db, task_id, new_value)
        local start_edit = [[
            UPDATE task SET start_time=? WHERE id=?
        ]]
        local start_stmt = db:prepare(start_edit)
        start_stmt:bind_values(
            new_value:fmt("${iso}"),
            task_id
        )
        start_stmt:step()
    end,

    end_time = function(db, task_id, new_value)
        local end_edit = [[
            UPDATE task SET end_time=? WHERE id=?
        ]]
        local end_stmt = db:prepare(end_edit)
        end_stmt:bind_values(
            new_value:fmt("${iso}"),
            task_id
        )
        end_stmt:step()
    end,

    description = function(db, task_id, new_value)
        local end_edit = [[
            UPDATE task SET description=? WHERE id=?
        ]]
        local end_stmt = db:prepare(end_edit)
        end_stmt:bind_values(
            new_value,
            task_id
        )
        end_stmt:step()
    end
}

return function(task_id, field, new_value)
    if not utils.has_key(edit_task_field, field) then
        print("Unknown field for task edit: "..field)
        return false
    end

    local db = sqlite3.open(conf.db)
    edit_task_field[field](db, task_id, new_value)
    db:close()

    return true
end
