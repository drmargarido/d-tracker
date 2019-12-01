local sqlite3 = require "lsqlite3"
local migrations = require "migrations.migrations"

local conf = require "src.conf"
local utils = require "src.utils"

local ui = require "src.ui.ui"

-- Create database if it doesn't exists
if not utils.file_exists(conf.db) then
    local db = sqlite3.open(
        conf.db,
        sqlite3.OPEN_READWRITE + sqlite3.OPEN_CREATE
    )

    -- Apply migrations
    migrations.run(db)
    require "migrations.mock_data"(db)
    db:close()
end

-- Start the UI
ui.init()
