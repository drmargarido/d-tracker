-- Utils
local date = require "date.date"

-- Decorators
local decorators = require "src.decorators"

return decorators.use_db(function(db)
    local stop_query = string.format(
        "UPDATE task SET end_time='%s' WHERE end_time IS NULL",
        date():fmt("${iso}")
    )

    db:exec(stop_query)
    return true, nil
end)
