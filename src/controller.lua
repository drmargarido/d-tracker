local sqlite3 = require "lsqlite3"
local conf = require "src.conf"

local date = require "date.date"

return {
   autocomplete_task = function(description)
      return {}
   end,
   add_task = function(description, project)
      local db = sqlite3.open(conf.db)
      -- Check if the project already exists
      local sql_check = "SELECT * FROM project WHERE name=?"
      local check_stmt = db:prepare(sql_check)
      check_stmt:bind_values(project)

      local project_exists = false
      for row in check_stmt:nrows() do
         project_exists = true
      end
      
      -- Create a new project if it doesn't exists
      if not project_exists then
         local sql_project = "INSERT INTO project (name) VALUES (?)"
         local project_stmt = db:prepare(sql_project)
         project_stmt:bind_values(project)
         project_stmt:step()
      end
      
      -- Create a new task starting at the current moment
      local sql_create = [[
            INSERT INTO task (project_id, start_time, description) 
            VALUES ((SELECT id FROM project WHERE name=?), ?, ?)
      ]]
      local project_stmt = db:prepare(sql_create)
      project_stmt:bind_values(
         project,
         date():fmt("${iso}"),
         description
      )
      project_stmt:step()
      
      db:close()
      return 0
   end,
   edit_task = function(task_id, field, new_value)
   end,
   delete_task = function(task_id)
   end,
   get_task_in_progress = function()
      return nil
   end,
   get_task = function(task_id)
      return {
         id=1,
         project="D-Tracker",
         start_time="2019-11-17T11:09:25",
         end_time="2019-11-17T12:09:25",
         description="Creating build setup"
      }
   end,
   list_tasks = function(start_date, end_date)
      local tasks = {}

      local db = sqlite3.open(conf.db)
      local today = date():fmt("%F")
      
      local query = string.format([[
         SELECT p.name as project, t.id, t.start_time, t.end_time, t.description
         FROM task as t
         LEFT JOIN project p ON p.id = t.project_id
         WHERE t.start_time > date('%s')
      ]], today)
      
      for row in db:nrows(query) do
         table.insert(tasks, {
            id=row.id,
            project=row.project,
            start_time=row.start_time,
            end_time=row.end_time,
            description=row.description
         })
      end      

      db:close()
      return tasks
   end
}
