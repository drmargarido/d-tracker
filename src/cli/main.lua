-- Controllers
local list_today_tasks = require "src.controller.list_today_tasks"
local list_tasks = require "src.controller.list_tasks"

-- Database
local migrations = require "src.migrations.migrations"

-- Utils
local print_task = require "src.utils".print_task
local date = require "date.date"

-- Arguments parsing
local argparse = require "argparse.argparse"

local parser = argparse(
    "d-tracker-cli",
    "Command line interface to interact with the d-tracker"
)

local todate = function(datestr)
    local status, result = pcall(date, datestr)
    if status then
        return result
    end

    return nil
end

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

parser
    :command("delete-task")
    :summary("Delete a specific task")
    :action(function(args, name)

    end)

parser
    :command("add-task")
    :summary("Add a new task")
    :action(function(args, name)

    end)

parser
    :command("edit-task-time")
    :summary("Edit the time of a specific time")
    :action(function(args, name)

    end)

parser
    :command("edit-task-description")
    :summary("Edit the description of a specific task")
    :action(function(args, name)

    end)

parser
    :command("edit-task-project")
    :summary("Edit the project of a specific task")
    :action(function(args, name)

    end)

parser
    :command("export-today-xml")
    :summary("Export today tasks to a xml file")
    :action(function(args, name)

    end)

parser
    :command("export-xml")
    :summary("Export tasks in a time range to a xml file")
    :action(function(args, name)

    end)

parser
    :command("stop-in-progress")
    :summary("Stop the current task in progress")
    :action(function(args, name)

    end)

-- Ensure database exist and is updated
migrations()

-- Parse commands
parser:parse()
return 0
