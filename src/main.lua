local date = require "date.date"
test_time = date(1999, 12, 27)
print(test_time)


local sqlite3 = require "lsqlite3"
local db = sqlite3.open_memory()

db:exec[[
  CREATE TABLE test (id INTEGER PRIMARY KEY, content);

  INSERT INTO test VALUES (NULL, 'Hello World');
  INSERT INTO test VALUES (NULL, 'Hello Lua');
  INSERT INTO test VALUES (NULL, 'Hello Sqlite3')
]]

for row in db:nrows("SELECT * FROM test") do
  print(row.id, row.content)
end

ui = require "tek.ui"
ui.Application:new{
  Children = {
    ui.Window:new {
      Title = "Timetracker",
      Children = {
        ui.Text:new{
          Text = "Hello, World!",
          Class = "button",
          Mode = "button",
          Width = "auto"
        }
      }
    }
  }
}:run()
