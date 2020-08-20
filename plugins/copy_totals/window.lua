-- UI
local ui = require "tek.ui"
local List = require "tek.class.list"

-- Scopes
local scopes = require "plugins.copy_totals.scopes"

-- Constants
local TASK_TAGS = {
  "@TASK_DESCRIPTION",
  "@TASK_PROJECT",
  "@TASK_DURATION",
  "@TASK_START_DATE",
  "@TASK_END_DATE"
}
local GROUPED_TASKS_TAGS = {
  "@TASK_DESCRIPTION",
  "@TASK_PROJECT",
  "@TASK_DURATION",
}
local SCOPE_TAGS = {
  [scopes.TASK_SCOPE] = {"@TASKS"},
  [scopes.PROJECT_SCOPE] = {"@TASKS", "@PROJECT", "@TIME_PROJECT"},
  [scopes.DAY_SCOPE] = {"@TASKS", "@DAY", "@MONTH", "@YEAR", "@TIME_DAY"}
}

-- Data
local scope = scopes.PROJECT_SCOPE -- Default scope
local group_tasks = false

-- Private helper methods
local get_tags_text = function(tags)
  local tags_text = "Available Tags: "
  for i, tag in ipairs(tags) do
    if i > 1 then
      tags_text = tags_text..", "
    end
    tags_text = tags_text..tag
  end
  return tags_text
end

local refresh_according_to_scope = function(self)
  -- Set template description
  self:getById("scope-template-title"):setValue("Text", scope.." Template:")

  -- Present available tags
  local task_tags = group_tasks and GROUPED_TASKS_TAGS or TASK_TAGS
  self:getById("task-format-tags"):setValue("Text", get_tags_text(task_tags))

  local tags_text = get_tags_text(SCOPE_TAGS[scope])
  self:getById("template-format-tags"):setValue("Text", tags_text)
end

local apply_changes = function(self, storage)
  local task_format = self:getById("copy-task-formatting"):getText()
  local template_format = self:getById("copy-template-formatting"):getText()

  storage.data.group_tasks = group_tasks
  storage.data.task_format = task_format
  storage.data.template_format = template_format
  storage.data.copy_scope = scope
  storage:save()

  self:getById("copy-totals-window"):setValue("Status", "hide")
end

-- Public window creation method
return function(storage)
  scope = storage.data.copy_scope
  group_tasks = storage.data.group_tasks

  local window = ui.Window:new{
    Title = "Copy Totals",
    Id = "copy-totals-window",
    Status = "hide",
    Style = "margin: 15;",
    Orientation = "vertical",
    Width = "free",
    Height = "free",
    Children = {
      ui.Group:new{
        Width = 600
      },
      ui.Group:new{
        Style = "margin-bottom: 15;",
        Children = {
          ui.Text:new{
            Width = "auto",
            Text = "Scope: ",
            Class = "caption label",
            Style = "font: 14/b;",
          },
          ui.PopList:new{
						Id = "scope-combo",
						Text = scope,
						Width = 75,
						ListObject = List:new{
							Items = {
								{ { "Task" } },
								{ { "Project" } },
								{ { "Day" } },
							}
						},
						onSelect = function(self)
							ui.PopList.onSelect(self)
							local item = self.ListObject:getItem(self.SelectedLine)
							if item then
								scope = item[1][1]
								refresh_according_to_scope(self)
							end
						end,
					},
        }
      },
      ui.Group:new{
        Style = "margin-bottom: 15;",
        Children = {
          ui.Text:new{
            Width = "auto",
            Text = "Group Tasks: ",
            Class = "caption label",
            Style = "font: 14/b;",
          },
          ui.CheckMark:new{
            Selected = group_tasks,
            onSelect = function(self)
              group_tasks = self.Selected
              refresh_according_to_scope(self)
            end
          },
        }
      },
      ui.Text:new{
        Width = "auto",
        Text = "Task Format:",
        Class = "caption label",
        Style = "font: 14/b;",
      },
      ui.Input:new{
        Id = "copy-task-formatting",
        Width = "fill",
        MultiLine = true,
        Height = 40,
        Text = storage.data.task_format,
      },
      ui.Text:new{
        Id = "task-format-tags",
        Width = "auto",
        Class = "caption",
        Style = [[
          margin-bottom: 15;
          font: sans-serif,helvetica,Vera:10;
        ]],
        Text = get_tags_text(group_tasks and GROUPED_TASKS_TAGS or TASK_TAGS)
      },
      ui.Text:new{
        Id = "scope-template-title",
        Width = "auto",
        Text = scope.." Template:",
        Class = "caption label",
        Style = "font: 14/b;",
      },
      ui.Input:new{
        Id = "copy-template-formatting",
        MultiLine = true,
        Width = "fill",
        Height = "free",
        Text = storage.data.template_format,
      },
      ui.Text:new{
        Id = "template-format-tags",
        Width = "auto",
        Class = "caption",
        Style = "font: sans-serif,helvetica,Vera:10;",
        Text = get_tags_text(SCOPE_TAGS[scope])
      },
      ui.Button:new{
        Text = "Apply",
        Width = 80,
        HAlign = "center",
        Style = "margin-top: 20;",
        onClick = function(self)
          apply_changes(self, storage)
        end
      }
    }
  }

  return window
end
