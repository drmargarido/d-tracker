-- Controllers
local create_project = require "src.controller.create_project"
local project_exists = require "src.controller.project_exists"

-- Utils
local conf = require "src.conf"

-- database
local sqlite3 = require "lsqlite3"
local mock_data = require "migrations.mock_data"
local migrations = require "migrations.migrations"

describe("Project Management", function()
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


    it("Creates a new project", function()
        assert.is_false(project_exists("New Test Project"))
        create_project("New Test Project")
        assert.is_true(project_exists("New Test Project"))
    end)

    it("Checks if project exists", function()
        assert.is_false(project_exists("New Test Project"))
        create_project("New Test Project")
        assert.is_true(project_exists("New Test Project"))
    end)
end)
