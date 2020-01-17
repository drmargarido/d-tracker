-- Controllers
local create_project = require "src.controller.create_project"
local autocomplete_project = require "src.controller.autocomplete_project"

-- validators
local db_validators = require "src.validators.db_validators"

-- Utils
local conf = require "src.conf"

-- database
local sqlite3 = require "lsqlite3"
local mock_data = require "src.migrations.mock_data"
local migrations = require "src.migrations.migrations"

describe("Project Management", function()
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


    it("Creates a new project", function()
        local project_exists, _ = db_validators.project_exists("New Test Project")
        assert.is_false(project_exists)
        create_project("New Test Project")

        project_exists, _ = db_validators.project_exists("New Test Project")
        assert.is_true(project_exists)
    end)

    it("Lists autocompleted projects by input text", function()
        local projects = autocomplete_project("Arg")
        assert.is_true(#projects == 1)

        projects = autocomplete_project("")
        assert.is_true(#projects == 2)

        projects = autocomplete_project("RANDOMNOTMATCHANY")
        assert.is_true(#projects == 0)
    end)
end)
