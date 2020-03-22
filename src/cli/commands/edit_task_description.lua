-- Controllers
local edit_task_description = require "src.controller.edit_task_description"

return function(parser)
    local edit_task_parser = parser:command("edit-task-description")
    edit_task_parser:summary("Edit the description of a specific task")
    edit_task_parser
        :argument("id", "Id of the task to edit")
        :convert(tonumber)

    edit_task_parser
        :argument("description", "The new description for the task")

    edit_task_parser:action(function(args, name)
        local _, err = edit_task_description(args.id, args.description)

        if err then
            print(err)
        end
    end)
end
