-- Controllers
local create_project = require "dtracker.controller.create_project"

-- validators
local db_validators = require "dtracker.validators.db_validators"

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
        local project_exists, _ = db_validators.project_exists("New Test Project")
        assert.is_false(project_exists)
        create_project("New Test Project")

        project_exists, _ = db_validators.project_exists("New Test Project")
        assert.is_true(project_exists)
    end)
end)
