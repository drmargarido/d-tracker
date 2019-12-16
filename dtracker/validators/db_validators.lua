-- Decorators
local decorators = require "dtracker.decorators"
local use_db = decorators.use_db

return {
    task_exists = use_db(function(db, data)
        local sql_check = "SELECT * FROM task WHERE id=?"
        local check_stmt = db:prepare(sql_check)
        check_stmt:bind_values(data)

        local task_exists = false
        for _ in check_stmt:nrows() do
            task_exists = true
        end

        if task_exists then
            return true, nil
        else
            return false, "The received task does not exist"
        end
    end),

    project_exists = use_db(function(db, data)
        local sql_check = "SELECT * FROM project WHERE name=?"
        local check_stmt = db:prepare(sql_check)
        check_stmt:bind_values(data)

        local project_exists = false
        for _ in check_stmt:nrows() do
            project_exists = true
        end

        if project_exists then
            return true, nil
        else
            return false, "The received project does not exist"
        end
    end),

    operation_ok = function(db)
        local error_code = db:errcode()
        if error_code > 0 and error_code < 100 then
            print(db:errmsg())
            return false, db:errmsg()
        end

        return true, nil
    end
}
