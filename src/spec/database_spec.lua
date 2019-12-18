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

-- Utils
local date = require "date.date"
local utils = require "src.utils"
local conf = require "src.conf"

-- Database
local migrations = require "src.migrations.migrations"

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

        migrations()
        assert.is_true(utils.file_exists(conf.db))

        -- Clear created database
        os.remove(conf.db)
    end)
end)
