-- Utils
local utils = require "src.utils"
local validators = require "src.validators.base_validators"
local db_validators = require "src.validators.db_validators"

-- Decorators
local decorators = require "src.decorators"
local use_db = decorators.use_db
local check_input = decorators.check_input

-- Controllers
local create_project = require "src.controller.create_project"

-- Strategy to edit each field of the task
local edit_task_field = {
    project = check_input(
        {
            {},
            {},
            {validators.is_text, validators.max_length(255)}
        },
        function(db, task_id, new_value)
            local project_exists, _ = db_validators.project_exists(new_value)
            if not project_exists then
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

            return true, nil
        end
    ),

    start_time = check_input(
        {
            {},
            {},
            {validators.is_date}
        },
        function(db, task_id, new_value)
            local start_edit = [[
                UPDATE task SET start_time=? WHERE id=?
            ]]
            local start_stmt = db:prepare(start_edit)
            start_stmt:bind_values(
                new_value:fmt("${iso}"),
                task_id
            )
            start_stmt:step()

            return true, nil
        end
    ),

    end_time = check_input(
        {
            {},
            {},
            {validators.is_date}
        },
        function(db, task_id, new_value)
            local end_edit = [[
                UPDATE task SET end_time=? WHERE id=?
            ]]
            local end_stmt = db:prepare(end_edit)
            end_stmt:bind_values(
                new_value:fmt("${iso}"),
                task_id
            )
            end_stmt:step()

            return true, nil
        end
    ),

    description = check_input(
        {
            {},
            {},
            {validators.is_text, validators.max_length(512)}
        },
        function(db, task_id, new_value)


            local end_edit = [[
                UPDATE task SET description=? WHERE id=?
            ]]
            local end_stmt = db:prepare(end_edit)
            end_stmt:bind_values(
                new_value,
                task_id
            )
            end_stmt:step()

            return true, nil
        end
    )
}

return check_input(
    {
        {validators.is_number},
        {
            validators.is_text,
            validators.one_of(utils.get_keys(edit_task_field))
        },
        {}
    },
    use_db(function(db, task_id, field, new_value)
        return edit_task_field[field](db, task_id, new_value)
    end)
)
