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
    local in_day = date and start_time:fmt("%d %B %Y") == day
    if get_all or in_project or in_day then
      local line = task_template
      line = line:gsub("@TASK_DESCRIPTION", task.description)
      line = line:gsub("@TASK_PROJECT", task.project)

      local end_time = date(task.end_time)
      local duration = date.diff(end_time, start_time)
      local duration_text = string.format(
        "%dh %dm", duration:spanhours(), duration:getminutes()
      )
      line = line:gsub("@TASK_DURATION", duration_text)
      line = line:gsub("@TASK_START_DATE", task.start_time)
      if task.end_time then
        line = line:gsub("@TASK_END_DATE", task.end_time)
      else
        line = line:gsub("@TASK_END_DATE", "")
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

local project_total_time = function(tasks, project)
  local total_time = nil
  for _, task in ipairs(tasks) do
    if task.project == project then
      local duration = date.diff(date(task.end_time), date(task.start_time))
      if not total_time then
        total_time = duration
      else
        total_time = total_time + duration
      end
    end
  end
  return total_time
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
    local project_time = project_total_time(tasks, project)
    local formatted_total = string.format(
      "%dh %dm", project_time:spanhours(), project_time:getminutes()
    )
    project_text = project_text:gsub("@TIME_PROJECT", formatted_total)
    text = text .. project_text
  end

  return text
end

local day_total_time = function(tasks, day)
  local total_time = nil
  for _, task in ipairs(tasks) do
    local start_time = date(task.start_time)
    if start_time:fmt("%d %B %Y") == day then
      local end_time = task.end_time and date(task.end_time) or date()
      local duration = date.diff(end_time, start_time)
      if not total_time then
        total_time = duration
      else
        total_time = total_time + duration
      end
    end
  end
  return total_time
end

local day_scope_formatting = function(tasks, task_format, template_format)
  local text = ""
  local days = {}
  for _, task in ipairs(tasks) do
    local d = date(task.start_time)
    days[d:fmt("%d %B %Y")] = d
  end

  for day, d in pairs(days) do
    local tasks_text = task_formatting(tasks, task_format, nil, day)
    local day_text = template_format
    day_text = day_text:gsub("@DAY", d:getday())
    day_text = day_text:gsub("@MONTH", d:getmonth())
    day_text = day_text:gsub("@YEAR", d:getyear())
    day_text = day_text:gsub("@TASKS", tasks_text)

    local day_total = day_total_time(tasks, day)
    local formatted_total = string.format(
      "%dh %dm", day_total:spanhours(), day_total:getminutes()
    )
    day_text = day_text:gsub("@TIME_DAY", formatted_total)

    text = text..day_text
  end
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
