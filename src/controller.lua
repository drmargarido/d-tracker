local date = require "date.date"
test_time = date(1999, 12, 27)
print(test_time)

local sqlite3 = require "lsqlite3"
local db = sqlite3.open()

for row in db:nrows("SELECT * FROM test") do
  print(row.id, row.content)
end


return {
    autocomplete_task = function(description)
        return {}
    end,
    add_task = function(description, project)
        return 0
    end,
    edit_task = function(task_id, field, new_value)
    end,
    delete_task = function(task_id)
    end,
    list_tasks = function(start_date, end_date)
        return {}
    end
}