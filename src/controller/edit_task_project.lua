-- Validators
local validators = require "src.validators.base_validators"
local db_validators = require "src.validators.db_validators"

-- Decorators
local decorators = require "src.decorators"
local use_db = decorators.use_db
local check_input = decorators.check_input
local use_events = decorators.use_events

-- Plugins
local events = require "src.plugin_manager.events"

-- Controllers
local create_project = require "src.controller.create_project"

return check_input(
    {
        {
            validators.is_number,
            db_validators.task_exists
        },
        {
            validators.is_text,
            validators.min_length(1),
            validators.max_length(255)
        }
    },
    use_events(use_db(function(db, events_queue, task_id, new_value)
        local project_exists, _ = db_validators.project_exists(new_value)
        if not project_exists then
            local _, err = create_project(new_value)
            if err ~= nil then
                return false, new_value.." - Failed to create the project"
            end
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

        local success, _ = db_validators.operation_ok(db)
        project_stmt:finalize()

        if not success then
            return false, new_value.." - Failed to edit the task project"
        end

        table.insert(events_queue, {
            id=events.TASK_EDIT,
            data={id=task_id, project=new_value}
        })
        return true, nil
    end))
)
