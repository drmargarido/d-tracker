-- Database
local sqlite3 = require "lsqlite3"

-- Utils
local conf = require "src.conf"
local utils = require "src.utils"

local migrations = {
    require "src.migrations.001_initialization"
}

return function()
    local is_new_db = not utils.file_exists(conf.db)

    local db = sqlite3.open(
        conf.db,
        sqlite3.OPEN_READWRITE + sqlite3.OPEN_CREATE
    )

    if db then
        local last_migration
        if is_new_db then
            last_migration = 0
        else
            local query = "SELECT COUNT(*) as total FROM migration"
            for row in db:nrows(query) do
                last_migration = row.total
            end
        end

        -- Apply migrations
        for i=last_migration+1, #migrations do
            local migration = migrations[i]
            migration.execute(db)
            db:exec(string.format(
                "INSERT INTO migration (name) VALUES (%s)", migration.name
            ))
        end

        db:close()
    else
        print("Failed to create the tasks database")
        return false, "Failed to create the tasks database"
    end

    return true, nil
end
