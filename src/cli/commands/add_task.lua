-- Controllers
local add_task = require "src.controller.add_task"

return function(parser)
    local add_task_parser = parser:command("add-task")

    add_task_parser:summary("Add a new task")
    add_task_parser
        :argument("description", "Description of the new task")

    add_task_parser
        :argument("project", "Name of the project associated with the task")

    add_task_parser:action(function(args, name)
        local _, err = add_task(args.description, args.project)
        if err then
            print(err)
        end

        return
    end)
end
