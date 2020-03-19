-- COntrollers
local edit_task_project = require "src.controller.edit_task_project"

return function(parser)

    local edit_task_parser = parser:command("edit-task-project")
    edit_task_parser:summary("Edit the project of a specific task")

    edit_task_parser
        :argument("id", "Id of the task to edit")
        :convert(tonumber)

    edit_task_parser
        :argument("project", "Name of the new project of the task")

    edit_task_parser:action(function(args, name)
        local _, err = edit_task_project(args.id, args.project)
        if err then
            print(err)
        end
    end)
end
