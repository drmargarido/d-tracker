-- Controllers
local list_tasks = require "src.controller.list_tasks"
local list_tasks_by_text = require "src.controller.list_tasks_by_text"

-- Date
local date = require "date.date"

-- Scopes
local scopes = require "plugins.copy_totals.scopes"

-- Utils
local utils = require "src.utils"

-- Private formatting methods
local group_task_formatting = function(tasks, task_template, project, day)
  local group_map = {} -- Group tasks by project and name
  local get_all = not project and not day
  for _, task in ipairs(tasks) do
    local start_time = date(task.start_time)
    local in_project = project and task.project == project
    local in_day = date and start_time:fmt("%d %B %Y") == day
    if get_all or in_project or in_day then
      if not group_map[task.project] then
        group_map[task.project] = {}
      end
      local project_map = group_map[task.project]

      local end_time = date(task.end_time)
      local duration = date.diff(end_time, start_time)
      if not project_map[task.description] then
        project_map[task.description] = duration
      else
        project_map[task.description] = project_map[task.description] + duration
      end
    end
  end


  local final_tasks = {}
  for proj, tasks_map in pairs(group_map) do
    for task, duration in pairs(tasks_map) do
      table.insert(final_tasks, {name=task, project=proj, duration=duration})
    end
  end

  -- Sort table by task durations
  table.sort(final_tasks, function(a, b) return a.duration > b.duration end)

  local text = ""
  for _, task in ipairs(final_tasks) do
    local line = task_template
    line = line:gsub("@TASK_DESCRIPTION", task.name)
    line = line:gsub("@TASK_PROJECT", task.project)

    local duration_text = string.format(
      "%dh %dm", task.duration:spanhours(), task.duration:getminutes()
    )
    line = line:gsub("@TASK_DURATION", duration_text)
    text = text..line.."\n"
  end
  return text
end

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

local task_scope_formatting = function(tasks, task_format, template_format, group_tasks)
  local text = template_format
  local tasks_text
  if group_tasks then
    tasks_text = group_task_formatting(tasks, task_format)
  else
    tasks_text = task_formatting(tasks, task_format)
  end
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

local project_scope_formatting = function(tasks, task_format, template_format, group_tasks)
  local projects = {}
  for _, task in ipairs(tasks) do
    if not projects[task.project] then
      projects[task.project] = true
    end
  end

  local text = ""
  for project, _ in pairs(projects) do
    local tasks_text
    if group_tasks then
      tasks_text = group_task_formatting(tasks, task_format, project)
    else
      tasks_text = task_formatting(tasks, task_format, project)
    end
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

local day_scope_formatting = function(tasks, task_format, template_format, group_tasks)
  local text = ""
  local days = {}
  for _, task in ipairs(tasks) do
    local d = date(task.start_time)
    days[d:fmt("%d %B %Y")] = d
  end

  local day_duration_map = {}
  local day_text_map = {}
  for day, d in pairs(days) do
    local tasks_text
    if group_tasks then
      tasks_text = group_task_formatting(tasks, task_format, nil, day)
    else
      tasks_text = task_formatting(tasks, task_format, nil, day)
    end
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

    day_duration_map[day] = d
    day_text_map[day] = day_text
  end

  local sorted_days_map = utils.sort_duration(day_duration_map)
  for _, entry in ipairs(sorted_days_map) do
    local day_text = day_text_map[entry.key]
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
  local data = storage.data
  local fmt = formatting_strategy[data.copy_scope]
  return fmt(tasks, data.task_format, data.template_format, data.group_tasks)
end
