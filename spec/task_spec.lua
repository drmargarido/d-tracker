local controller = require "src.controller"

local conf = require "src.conf"
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
        local before_tasks = controller.list_tasks(date(1970, 1, 1), date())

        controller.add_task("A new task", "D-Tracker")

        local after_tasks = controller.list_tasks(date(1970, 1, 1), date())
        assert.is_true(#before_tasks + 1 == #after_tasks)
    end)

    it("Lists today's tasks", function()
       local tasks = controller.list_today_tasks()
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
       controller.add_task("A new task", "D-Tracker")

       local tasks = controller.list_tasks(date(1970, 1, 1), date())
       local last_task = tasks[#tasks]
       assert.is_true(last_task.end_time == nil)

       controller.stop_task()

       tasks = controller.list_tasks(date(1970, 1, 1), date())
       last_task = tasks[#tasks]
       assert.is_false(last_task.end_time == nil)
    end)

    it("Deletes task", function()
    end)
end)
