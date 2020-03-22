-- Controllers
local delete_task = require "src.controller.delete_task"

return function(parser)
    local delete_task_command = parser:command("delete-task")
    delete_task_command:summary("Delete a specific task")

    delete_task_command
        :argument("id", "Identifier of the task to remove")
        :convert(tonumber)

    delete_task_command:action(function(args, name)
        delete_task(args.id)
        return
    end)
end
