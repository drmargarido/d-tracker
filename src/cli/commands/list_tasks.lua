-- Controllers
local list_tasks = require "src.controller.list_tasks"

-- Utils
local date = require "date.date"
local utils = require "src.utils"
local print_task = utils.print_task
local todate = utils.todate

return function(parser)
    local list_tasks_command = parser:command("list-tasks")
    list_tasks_command:summary("List tasks between a time range")
    list_tasks_command
        :option("-b --before", "Starting a number of days before today")
        :convert(tonumber)
        :count("0-1")

    list_tasks_command
        :option("-f --from", "From the given date")
        :convert(todate)
        :count("0-1")

    list_tasks_command
        :option("-t --to", "To the given date")
        :convert(todate)
        :count("0-1")

    list_tasks_command:action(function(args, name)
        local tasks, err
        if not args.before and (not args.from or not args.to) then
            print(list_tasks_command:get_usage())
            return
        end

        if args.before then
            local start_date = date():adddays(-args.before)
            tasks, err = list_tasks(start_date, date())
        end

        if args.from and args.to then
            tasks, err = list_tasks(args.from, args.to)
        end

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
