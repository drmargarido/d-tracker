-- Controllers
local list_tasks = require "src.controller.list_tasks"
local list_tasks_by_text = require "src.controller.list_tasks_by_text"

-- Utils
local utils = require "src.utils"

return function(start_date, end_date, description)
  -- Get Tasks
  local tasks
  if description and #description > 0 then
    tasks = list_tasks_by_text(start_date, end_date, description)
  else
    tasks = list_tasks(start_date, end_date)
  end

  -- Create tasks formatted text
  local text = ""
  for _, task in ipairs(tasks) do
    text = text..utils.format_task(task).."\n"

  end
  return text
end
