-- Database
local sqlite3 = require "lsqlite3"
local migrations = require "src.migrations.migrations"

-- Utils
local conf = require "src.conf"

return function()
    local db = sqlite3.open(
        conf.db,
        sqlite3.OPEN_READWRITE + sqlite3.OPEN_CREATE
    )

    if db then
        -- Apply migrations
        migrations.run(db)

        db:close()
    else
        print("Failed to create the tasks database")
        return false, "Failed to create the tasks database"
    end

    return true, nil
end
