local sqlite3 = require "lsqlite3"
local conf = require "src.conf"
local date = require "date.date"

return function()
    local db = sqlite3.open(conf.db)

    local stop_query = string.format(
        "UPDATE task SET end_time='%s' WHERE end_time IS NULL",
        date():fmt("${iso}")
    )

    db:exec(stop_query)
    db:close()
end
