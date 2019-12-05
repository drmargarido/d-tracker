-- Controllers
local add_task = require "src.controller.add_task"
local get_task = require "src.controller.get_task"
local stop_task = require "src.controller.stop_task"
local edit_task = require "src.controller.edit_task"
local list_tasks = require "src.controller.list_tasks"
local delete_task = require "src.controller.delete_task"
local list_today_tasks = require "src.controller.list_today_tasks"
local get_task_in_progress = require "src.controller.get_task_in_progress"
local set_task_in_progress = require "src.controller.set_task_in_progress"

-- Exporters
local xml_export = require "src.exporter.xml"

-- Utils
local conf = require "src.conf"
local date = require "date.date"
local utils = require "src.utils"

-- database
local sqlite3 = require "lsqlite3"
local mock_data = require "migrations.mock_data"
local migrations = require "migrations.migrations"

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
        local tasks = list_tasks(date(1970, 1, 1), date())
        local last_task = tasks[#tasks]

        edit_task(last_task.id, "description", "Testing Edit Description")
        local edited_task = get_task(last_task.id)

        assert.is_true(last_task.description ~= edited_task.description)
    end)

    it("Changes the task associated project", function()
        local tasks = list_tasks(date(1970, 1, 1), date())
        local last_task = tasks[#tasks]

        edit_task(last_task.id, "project", "New Random Project")
        local edited_task = get_task(last_task.id)

        assert.is_true(last_task.project ~= edited_task.project)
    end)

    it("Changes the task start date", function()
        local tasks = list_tasks(date(1970, 1, 1), date())
        local last_task = tasks[#tasks]

        edit_task(last_task.id, "start_time", date(2019,10,05,22,14,32))
        local edited_task = get_task(last_task.id)

        assert.is_true(last_task.start_time ~= edited_task.start_time)
    end)

    it("Changes the task end date", function()
        local tasks = list_tasks(date(1970, 1, 1), date())
        local last_task = tasks[#tasks]

        edit_task(last_task.id, "end_time", date(2019,10,05,22,14,32))
        local edited_task = get_task(last_task.id)

        assert.is_true(last_task.end_time ~= edited_task.end_time)
    end)

    it("Edits if the task is in progress", function()
        local task_id = get_task_in_progress().id

        stop_task()

        local task_in_progress = get_task_in_progress()
        assert.is_true(task_in_progress == nil)

        set_task_in_progress(task_id)

        task_in_progress = get_task_in_progress()
        assert.is_true(task_in_progress.id == task_id)
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
