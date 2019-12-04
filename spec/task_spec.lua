-- Controllers
local list_tasks = require "src.controller.list_tasks"
local list_today_tasks = require "src.controller.list_today_tasks"
local add_task = require "src.controller.add_task"
local stop_task = require "src.controller.stop_task"
local delete_task = require "src.controller.delete_task"

-- Exporters
local xml_export = require "src.exporter.xml"

-- Utils
local conf = require "src.conf"
local utils = require "src.utils"
local date = require "date.date"

-- database
local sqlite3 = require "lsqlite3"
local migrations = require "migrations.migrations"
local mock_data = require "migrations.mock_data"

describe("Tasks management", function()
    setup(function()
        conf.db = "testdb.sqlite3"
    end)

    before_each(function()
        -- Create database
        local db = sqlite3.open(
           conf.db,
           sqlite3.OPEN_READWRITE + sqlite3.OPEN_CREATE
        )

        -- Run migrations
        migrations.run(db)

        -- Add mock data
        mock_data(db)

        db:close()
    end)

    after_each(function()
        -- Destroy database
        os.remove(conf.db)
    end)

    it("Creates a task", function()
        local before_tasks = list_tasks(date(1970, 1, 1), date())

        add_task("A new task", "D-Tracker")

        local after_tasks = list_tasks(date(1970, 1, 1), date())
        assert.is_true(#before_tasks + 1 == #after_tasks)
    end)

    it("Lists today's tasks", function()
       local tasks = list_today_tasks()
       assert.is_true(#tasks == 2)
    end)

    it("Changes the task description", function()
    end)

    it("Changes the task associated project", function()
    end)

    it("Changes the task start date", function()
    end)

    it("Changes the task end date", function()
    end)

    it("Stops running task", function()
       add_task("A new task", "D-Tracker")

       local tasks = list_tasks(date(1970, 1, 1), date())
       local last_task = tasks[#tasks]
       assert.is_true(last_task.end_time == nil)

       stop_task()

       tasks = list_tasks(date(1970, 1, 1), date())
       last_task = tasks[#tasks]
       assert.is_false(last_task.end_time == nil)
    end)

    it("Deletes task", function()
        local before_tasks = list_tasks(date(1970, 1, 1), date())

        delete_task(before_tasks[1].id)

        local after_tasks = list_tasks(date(1970, 1, 1), date())
        assert.is_true(#before_tasks == #after_tasks + 1)
    end)

    it("Exports tasks list to XML", function()
        local tasks = list_tasks(date(1970, 1, 1), date())
        local filename = "test_export_tasks.xml"

        assert.is_false(utils.file_exists(filename))

        xml_export(tasks, filename)
        assert.is_true(utils.file_exists(filename))

        -- Clear file from filesystem
        os.remove(filename)
    end)
end)
