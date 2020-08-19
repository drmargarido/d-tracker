-- Controllers
local list_tasks = require "src.controller.list_tasks"
local list_tasks_by_text = require "src.controller.list_tasks_by_text"

-- Date
local date = require "date.date"

-- Scopes
local scopes = require "plugins.copy_totals.scopes"

-- Private formatting methods
local task_formatting = function(tasks, task_template, project, day)
  local text = ""
  local get_all = not project and not day
  for _, task in ipairs(tasks) do
    local start_time = date(task.start_time)
    local in_project = project and task.project == project
    local in_day = date and start_time == day
    if get_all or in_project or in_day then
      local line = task_template
      line = line:gsub("@TASK_DESCRIPTION", task.description)
      line = line:gsub("@TASK_PROJECT", task.project)

      local end_time = date(task.end_time)
      local duration = date.diff(end_time, start_time)
      line = line:gsub("@TASK_DURATION", duration:spanminutes())
      line = line:gsub("@TASK_START_DATE", task.start_time)
      if task.end_time then
        line = line:gsub("@TASK_END_DATE", task.end_time)
      end
      text = text .. line .. "\n"
    end
  end
  return text
end

local task_scope_formatting = function(tasks, task_format, template_format)
  local text = template_format
  local tasks_text = task_formatting(tasks, task_format)
  text = text:gsub("@TASKS", tasks_text)
  return text
end

local project_scope_formatting = function(tasks, task_format, template_format)
  local projects = {}
  for _, task in ipairs(tasks) do
    if not projects[task.project] then
      projects[task.project] = true
    end
  end

  local text = ""
  for project, _ in pairs(projects) do
    local tasks_text = task_formatting(tasks, task_format, project)
    local project_text = template_format
    project_text = project_text:gsub("@PROJECT", project)
    project_text = project_text:gsub("@TASKS", tasks_text)
    text = text .. project_text
  end

  return text
end

local day_scope_formatting = function(tasks, task_format, template_format)
  local text = template_format
  local tasks_text = task_formatting(tasks, task_format)
  return text
end

local formatting_strategy = {
  [scopes.TASK_SCOPE] = task_scope_formatting,
  [scopes.PROJECT_SCOPE] = project_scope_formatting,
  [scopes.DAY_SCOPE] = day_scope_formatting
}

-- Public formatting function
return function(start_date, end_date, description, storage)
  -- Get Tasks
  local tasks
  if description and #description > 0 then
    tasks = list_tasks_by_text(start_date, end_date, description)
  else
    tasks = list_tasks(start_date, end_date)
  end

  -- Create tasks formatted text
  local fmt = formatting_strategy[storage.data.copy_scope]
  return fmt(tasks, storage.data.task_format, storage.data.template_format)
end
