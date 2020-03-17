-- Controllers
local list_today_tasks = require "src.controller.list_today_tasks"
local list_tasks = require "src.controller.list_tasks"

-- Utils
local print_task = require "src.utils".print_task

-- Arguments parsing
local argparse = require "argparse.argparse"

local parser = argparse(
    "d-tracker-cli",
    "Command line interface to interact with the d-tracker"
)

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

parser
    :command("list-tasks")
    :summary("List tasks between a time range")
    :action(function(args, name)

        --[[
        local tasks, err = list_tasks()
        if err then
            print(err)
            return 1
        end

        print("id|project|start_time|end_time|description")
        print("------------------------------------------")

        for _, task in ipairs(tasks) do
            print_task(task)
        end
        ]]
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

parser:parse()
return 0
