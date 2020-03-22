-- Controllers
local get_task = require "src.controller.get_task"
local edit_task_time = require "src.controller.edit_task_time"

-- Utils
local date = require "date.date"
local todate = require "src.utils".todate

return function(parser)
    local edit_task_parser = parser:command("edit-task-time")
    edit_task_parser:summary("Edit the time of a specific time")

    edit_task_parser
        :argument("id", "Id of the task to edit")
        :convert(tonumber)

    edit_task_parser
        :option("-s --start", "Start time of the task")
        :convert(todate)
        :count("0-1")

    edit_task_parser
        :option("-e --end", "End time of the task")
        :convert(todate)
        :count("0-1")

    edit_task_parser
        :flag("-p --progress", "Put the task in progress")

    edit_task_parser:action(function(args, name)
        if not args.start and not args["end"] and not args.progress then
            print(edit_task_parser:get_usage())
            return
        end

        if args.progress and args["end"] then
            print("Cannot set an end date and put the task in progress at the same time.")
            return
        end

        local task, err = get_task(args.id)
        if err then
            print(err)
            return
        end

        local start_date = args.start or date(task.start_time)
        local end_date = args["end"] or nil

        local _, edit_err = edit_task_time(args.id, start_date, end_date)
        if edit_err then
            print(edit_err)
            return
        end
    end)
end
