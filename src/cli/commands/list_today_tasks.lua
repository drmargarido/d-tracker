local list_today_tasks = require "src.controller.list_today_tasks"

-- Utils
local utils = require "src.utils"
local print_task = utils.print_task

return function(parser)
    parser
        :command("list-today-tasks")
        :summary("List today tasks")
        :action(function(args, name)
            local tasks, err = list_today_tasks()
            if err then
                print(err)
                return 1
            end

            print("id|project|start_time|end_time|description")
            print("------------------------------------------")
            for _, task in ipairs(tasks) do
                print_task(task)
            end
        end)
end
