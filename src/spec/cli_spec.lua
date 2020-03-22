-- Controllers
local get_task = require "src.controller.get_task"
local get_task_in_progress = require "src.controller.get_task_in_progress"

-- Utils
local conf = require "src.conf"

-- database
local sqlite3 = require "lsqlite3"
local mock_data = require "src.migrations.mock_data"
local migrations = require "src.migrations.migrations"

describe("Base Path of Tasks management", function()
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

    it("Run list-today-tasks command", function()
        local result = os.execute("./d-tracker-cli list-today-tasks")
        assert.is_true(result == 0)
    end)

    it("Run list-tasks command", function()
        local result = os.execute("./d-tracker-cli list-tasks -b 10")
        assert.is_true(result == 0)
    end)

    it("Run list-projects command", function()
        local result = os.execute("./d-tracker-cli list-projects")
        assert.is_true(result == 0)
    end)

    it("Run delete-task command", function()
        local task_in_progress, err = get_task_in_progress()
        assert.is_true(err == nil)

        local result = os.execute(string.format(
            "./d-tracker-cli delete-task %d", task_in_progress.id
        ))
        assert.is_true(result == 0)

        local after_task, _ = get_task(task_in_progress.id)
        assert.is_true(after_task == nil)
    end)

    it("Run add-task command", function()
        local result = os.execute(
            "./d-tracker-cli add-task 'New task' 'D-tracker'"
        )
        assert.is_true(result == 0)

        local task_in_progress = get_task_in_progress()
        assert.is_true(task_in_progress.description == "New task")
    end)

    it("Run edit-task-time command", function()
        local task_in_progress, err = get_task_in_progress()
        assert.is_true(err == nil)

        local result = os.execute(string.format(
            "./d-tracker-cli edit-task-time %d -s '%s' -e '%s'",
            task_in_progress.id,
            "2020-01-01T19:02:02",
            "2020-01-01T20:01:01"
        ))
        assert.is_true(result == 0)

        local after_task_in_progress = get_task_in_progress()
        assert.is_true(after_task_in_progress == nil)
    end)

    it("Run edit-task-description command", function()
        local task_in_progress, err = get_task_in_progress()
        assert.is_true(err == nil)

        local result = os.execute(string.format(
            "./d-tracker-cli edit-task-description %d '%s'",
            task_in_progress.id, "Changed Description"
        ))
        assert.is_true(result == 0)

        local task_after_change, _ = get_task(task_in_progress.id)
        assert.is_true(
            task_after_change.description == "Changed Description"
        )
    end)

    it("Run edit-task-project command", function()
        local task_in_progress, err = get_task_in_progress()
        assert.is_true(err == nil)

        local result = os.execute(string.format(
            "./d-tracker-cli edit-task-project %d '%s'",
            task_in_progress.id, "New Project"
        ))
        assert.is_true(result == 0)

        local task_after_change, _ = get_task(task_in_progress.id)
        assert.is_true(task_after_change.project == "New Project")
    end)

    it("Run export-today-xml command", function()
        local result = os.execute("./d-tracker-cli export-today-xml")
        assert.is_true(result == 0)
    end)

    it("Run export-xml command", function()
        local result = os.execute("./d-tracker-cli export-xml -b 5")
        assert.is_true(result == 0)
    end)

    it("Run stop-in-progress command", function()
        local task_in_progress, err = get_task_in_progress()
        assert.is_true(err == nil)

        local result = os.execute("./d-tracker-cli stop-in-progress")
        assert.is_true(result == 0)

        local after_task_in_progress, err = get_task_in_progress()
        assert.is_true(after_task_in_progress == nil)
    end)
end)
