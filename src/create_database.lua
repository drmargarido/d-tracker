-- Database
local sqlite3 = require "lsqlite3"
local migrations = require "migrations.migrations"

-- Utils
local conf = require "src.conf"

return function()
    local db = sqlite3.open(
        conf.db,
        sqlite3.OPEN_READWRITE + sqlite3.OPEN_CREATE
    )

    -- Apply migrations
    migrations.run(db)

    db:close()
end
