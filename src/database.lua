local sqlite3 = require "lsqlite3"
local conf = require "src.conf"

return {
    initialize = function()
        db = sqlite3.open(conf.db)
    end,
    close = function()
        db:close()
    end
}
