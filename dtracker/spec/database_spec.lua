-- Controllers
local add_task = require "dtracker.controller.add_task"
local get_task = require "dtracker.controller.get_task"
local stop_task = require "dtracker.controller.stop_task"
local edit_task = require "dtracker.controller.edit_task"
local list_tasks = require "dtracker.controller.list_tasks"
local delete_task = require "dtracker.controller.delete_task"
local list_today_tasks = require "dtracker.controller.list_today_tasks"
local get_task_in_progress = require "dtracker.controller.get_task_in_progress"
local set_task_in_progress = require "dtracker.controller.set_task_in_progress"

-- Utils
local date = require "date.date"
local utils = require "dtracker.utils"
local conf = require "dtracker.conf"

-- Database
local create_database = require "dtracker.create_database"

describe("Operations without database", function()
    setup(function()
        conf.db = "testdb.sqlite3"
    end)


    it("Try to call controllers", function()
        local _, err = add_task("new Task", "D-Tracker")
        assert.is_true(err ~= nil)

        _, err = get_task(1)
        assert.is_true(err ~= nil)

        _, err = stop_task()
        assert.is_true(err ~= nil)

        _, err = edit_task(1, "description", "New Description")
        assert.is_true(err ~= nil)

        _, err = list_tasks(date(), date())
        assert.is_true(err ~= nil)

        _, err = delete_task(1)
        assert.is_true(err ~= nil)

        _, err = list_today_tasks()
        assert.is_true(err ~= nil)

        _, err = get_task_in_progress()
        assert.is_true(err ~= nil)

        _, err = set_task_in_progress(1)
        assert.is_true(err ~= nil)
    end)

    it("Create a new database", function()
        assert.is_false(utils.file_exists(conf.db))

        create_database()
        assert.is_true(utils.file_exists(conf.db))

        -- Clear created database
        os.remove(conf.db)
    end)
end)
