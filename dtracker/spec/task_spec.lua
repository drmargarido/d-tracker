-- Controllers
local add_task = require "dtracker.controller.add_task"
local get_task = require "dtracker.controller.get_task"
local stop_task = require "dtracker.controller.stop_task"
local edit_task = require "dtracker.controller.edit_task"
local list_tasks = require "dtracker.controller.list_tasks"
local delete_task = require "dtracker.controller.delete_task"
local list_today_tasks = require "dtracker.controller.list_today_tasks"
local list_tasks_by_text = require "dtracker.controller.list_tasks_by_text"
local get_task_in_progress = require "dtracker.controller.get_task_in_progress"
local set_task_in_progress = require "dtracker.controller.set_task_in_progress"

-- Exporters
local xml_export = require "dtracker.exporter.xml"

-- Utils
local conf = require "dtracker.conf"
local date = require "date.date"
local utils = require "dtracker.utils"

-- database
local sqlite3 = require "lsqlite3"
local mock_data = require "migrations.mock_data"
local migrations = require "migrations.migrations"

describe("Base Path of Tasks management", function()
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

    it("Lists tasks by text", function()
        local tasks = list_tasks_by_text(date(1970, 1, 1), date(), "Dev")
        assert.is_true(#tasks == 2)

        tasks = list_tasks_by_text(date(1970, 1, 1), date(), "Arglan2")
        assert.is_true(#tasks == 3)
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

describe("Invalid input types in tasks management", function()
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

    it("Tries to create a task with invalid fields", function()
        local before_tasks = list_tasks(date(1970, 1, 1), date())

        local _, err = add_task(nil, "D-Tracker")
        assert.is_false(err == nil)

        _, err = add_task("A good description", 123)
        assert.is_false(err == nil)

        local after_tasks = list_tasks(date(1970, 1, 1), date())
        assert.is_true(#before_tasks == #after_tasks)
    end)

    it("Tries to change a task description with invalid inputs", function()
        local tasks = list_tasks(date(1970, 1, 1), date())
        local last_task = tasks[#tasks]

        local _, err = edit_task(last_task.id, "description", 123)
        assert.is_false(err == nil)

        _, err = edit_task(last_task.id, "description", nil)
        assert.is_false(err == nil)

        _, err = edit_task(last_task.id, "description", {})
        assert.is_false(err == nil)

        local edited_task = get_task(last_task.id)
        assert.is_true(last_task.description == edited_task.description)
    end)

    it("Tries to change the task associated project with invalid data", function()
        local tasks = list_tasks(date(1970, 1, 1), date())
        local last_task = tasks[#tasks]

        local _,err = edit_task(last_task.id, "project", 123)
        assert.is_false(err == nil)

        _,err = edit_task(last_task.id, "project", nil)
        assert.is_false(err == nil)

        _,err = edit_task(last_task.id, "project", {})
        assert.is_false(err == nil)

        local edited_task = get_task(last_task.id)
        assert.is_true(last_task.project == edited_task.project)
    end)

    it("Tries to change the task start date with invalid data", function()
        local tasks = list_tasks(date(1970, 1, 1), date())
        local last_task = tasks[#tasks]

        local _, err = edit_task(last_task.id, "start_time", "2019/11/27T22:45:27")
        assert.is_false(err == nil)

        _, err = edit_task(last_task.id, "start_time", "Random Text")
        assert.is_false(err == nil)

        _, err = edit_task(last_task.id, "start_time", 123)
        assert.is_false(err == nil)

        _, err = edit_task(last_task.id, "start_time", {})
        assert.is_false(err == nil)

        _, err = edit_task(last_task.id, "start_time", nil)
        assert.is_false(err == nil)

        local edited_task = get_task(last_task.id)
        assert.is_true(last_task.start_time == edited_task.start_time)
    end)

    it("Tries to change the task end date with invalid data", function()
        local tasks = list_tasks(date(1970, 1, 1), date())
        local last_task = tasks[#tasks]

        local _, err = edit_task(last_task.id, "end_time", "2019/11/27T22:45:27")
        assert.is_false(err == nil)

        _, err = edit_task(last_task.id, "end_time", "Random Text")
        assert.is_false(err == nil)

        _, err = edit_task(last_task.id, "end_time", 123)
        assert.is_false(err == nil)

        _, err = edit_task(last_task.id, "end_time", {})
        assert.is_false(err == nil)

        _, err = edit_task(last_task.id, "end_time", nil)
        assert.is_false(err == nil)

        local edited_task = get_task(last_task.id)
        assert.is_true(last_task.end_time == edited_task.end_time)
    end)

    it("Tries to edits if the task is in progress with invalid data", function()
        local task_id = get_task_in_progress().id

        stop_task()

        local task_in_progress = get_task_in_progress()
        assert.is_true(task_in_progress == nil)

        local _, err = set_task_in_progress("asd")
        assert.is_false(err == nil)

        _, err = set_task_in_progress(nil)
        assert.is_false(err == nil)

        _, err = set_task_in_progress({})
        assert.is_false(err == nil)

        _, err = set_task_in_progress(-1)
        assert.is_false(err == nil)

        _, err = set_task_in_progress(10000)
        assert.is_false(err == nil)

        task_in_progress = get_task_in_progress()
        assert.is_true(task_in_progress == nil)
    end)

    it("Tries to delete a task with invalid data", function()
        local before_tasks = list_tasks(date(1970, 1, 1), date())

        local _, err = delete_task("asd")
        assert.is_false(err == nil)

        _, err = delete_task(nil)
        assert.is_false(err == nil)

        _, err = delete_task({})
        assert.is_false(err == nil)

        _, err = delete_task(-1)
        assert.is_false(err == nil)

        _, err = delete_task(10000)
        assert.is_false(err == nil)

        local after_tasks = list_tasks(date(1970, 1, 1), date())
        assert.is_true(#before_tasks == #after_tasks)
    end)

    it("Tries to get tasks by text with invalid data", function()
        local _, err = list_tasks_by_text(date(1970, 1, 1), date(), nil)
        assert.is_false(err == nil)

        _, err = list_tasks_by_text(date(1970, 1, 1), date(), 123)
        assert.is_false(err == nil)
    end)
end)
