-- Controllers
local add_task = require "src.controller.add_task"
local get_task = require "src.controller.get_task"
local stop_task = require "src.controller.stop_task"
local list_tasks = require "src.controller.list_tasks"
local delete_task = require "src.controller.delete_task"
local edit_task_time = require "src.controller.edit_task_time"
local list_today_tasks = require "src.controller.list_today_tasks"
local edit_task_project = require "src.controller.edit_task_project"
local autocomplete_task = require "src.controller.autocomplete_task"
local list_tasks_by_text = require "src.controller.list_tasks_by_text"
local get_task_in_progress = require "src.controller.get_task_in_progress"
local set_task_in_progress = require "src.controller.set_task_in_progress"
local edit_task_description = require "src.controller.edit_task_description"
local get_task_by_description = require "src.controller.get_task_by_description"

-- Exporters
local xml_export = require "src.exporter.xml"

-- Utils
local conf = require "src.conf"
local date = require "date.date"
local utils = require "src.utils"

-- database
local sqlite3 = require "lsqlite3"
local mock_data = require "src.migrations.mock_data"
local migrations = require "src.migrations.migrations"

describe("Base Path of Tasks management", function()
    setup(function()
        conf.db = "testdb.sqlite3"
    end)

    before_each(function()
        -- Create and open database
        migrations()

        local db = sqlite3.open(
           conf.db,
           sqlite3.OPEN_READWRITE
        )

        -- Add mock data
        mock_data(db)

        db:close()
    end)

    after_each(function()
        -- Destroy database
        os.remove(conf.db)
    end)

    it("Creates a task", function()
        local future = date():addhours(1)
        local before_tasks = list_tasks(date(1970, 1, 1), future)

        result, err = add_task("A new task", "D-Tracker")

        local after_tasks = list_tasks(date(1970, 1, 1), future)

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

        edit_task_description(last_task.id, "Testing Edit Description")
        local edited_task = get_task(last_task.id)

        assert.is_true(last_task.description ~= edited_task.description)
    end)

    it("Changes the task associated project", function()
        local tasks = list_tasks(date(1970, 1, 1), date())
        local last_task = tasks[#tasks]

        edit_task_project(last_task.id, "New Random Project")
        local edited_task = get_task(last_task.id)

        assert.is_true(last_task.project ~= edited_task.project)
    end)

    it("Changes the task date", function()
        local tasks = list_tasks(date(1970, 1, 1), date())
        local last_task = tasks[#tasks]

        edit_task_time(last_task.id, date(2019,09,05,22,14,32), date(2019,10,05,22,14,32))
        local edited_task = get_task(last_task.id)

        assert.is_true(last_task.start_time ~= edited_task.start_time)
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

       local future = date():addhours(1)
       local tasks = list_tasks(date(1970, 1, 1), future)
       local last_task = tasks[#tasks]
       assert.is_true(last_task.end_time == nil)

       stop_task()

       tasks = list_tasks(date(1970, 1, 1), future)
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

    it("Gets a task by its description", function()
        local description = "Defining Milestones"
        local task, err = get_task_by_description(description)
        assert.is_true(err == nil)
        assert.is_true(task.project == "D-Tracker")
        assert.is_true(task.description == description)
    end)

    it("Lists autocompleted tasks by input text", function()
        local tasks = autocomplete_task("Dev")
        assert.is_true(#tasks == 2)

        tasks = autocomplete_task("")
        assert.is_true(#tasks == 5)

        tasks = autocomplete_task("THISSTRINGWILLNOTMATCHANY")
        assert.is_true(#tasks == 0)
    end)
end)

describe("Invalid input types in tasks management", function()
    setup(function()
        conf.db = "testdb.sqlite3"
    end)

    before_each(function()
        -- Create and open database
        migrations()

        local db = sqlite3.open(
           conf.db,
           sqlite3.OPEN_READWRITE
        )

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

        local _, err = edit_task_description(last_task.id, 123)
        assert.is_false(err == nil)

        _, err = edit_task_description(last_task.id, nil)
        assert.is_false(err == nil)

        _, err = edit_task_description(last_task.id, {})
        assert.is_false(err == nil)

        local edited_task = get_task(last_task.id)
        assert.is_true(last_task.description == edited_task.description)
    end)

    it("Tries to change the task associated project with invalid data", function()
        local tasks = list_tasks(date(1970, 1, 1), date())
        local last_task = tasks[#tasks]

        local _,err = edit_task_project(last_task.id, 123)
        assert.is_false(err == nil)

        _,err = edit_task_project(last_task.id, nil)
        assert.is_false(err == nil)

        _,err = edit_task_project(last_task.id, {})
        assert.is_false(err == nil)

        local edited_task = get_task(last_task.id)
        assert.is_true(last_task.project == edited_task.project)
    end)

    it("Tries to change the task dates with invalid data", function()
        local tasks = list_tasks(date(1970, 1, 1), date())
        local last_task = tasks[#tasks]

        local _, err = edit_task_time(last_task.id, "2019/11/26T22:45:27", "2019/11/27T22:45:27")
        assert.is_false(err == nil)

        _, err = edit_task_time(last_task.id, "Random Text", "Random Text")
        assert.is_false(err == nil)

        _, err = edit_task_time(last_task.id, 123, 123)
        assert.is_false(err == nil)

        _, err = edit_task_time(last_task.id, {}, {})
        assert.is_false(err == nil)

        _, err = edit_task_time(last_task.id, nil, nil)
        assert.is_false(err == nil)

        -- Start date after end date
        _, err = edit_task_time(last_task.id, date(2019,10,05,22,14,32), date(2019,09,05,22,14,32))
        assert.is_false(err == nil)

        -- Date overlaps with another task
        _, err = edit_task_time(last_task.id, date(2019,11,23,11,23,32), date(2019,11,23,13,14,32))
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
