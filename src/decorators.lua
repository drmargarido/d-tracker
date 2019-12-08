local sqlite3 = require "lsqlite3"
local conf = require "src.conf"

return {
    use_db = function(func)
        return function(...)
            local db = sqlite3.open(conf.db, sqlite3.OPEN_READWRITE)
            if not db then
                print("Failed to open database")
                return nil, "Failed to open database"
            end

            local result, err = func(db, ...)

            db:close()
            return result, err
        end
    end
}
