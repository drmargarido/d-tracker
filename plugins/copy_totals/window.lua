-- UI
local ui = require "tek.ui"
local List = require "tek.class.list"

-- Constants
local TASK_SCOPE = "Task"
local PROJECT_SCOPE = "Project"
local DAY_SCOPE = "Day"
local TASK_TAGS = {
  "@TASK_DESCRIPTION",
  "@TASK_PROJECT",
  "@TASK_DURATION",
  "@TASK_START_DATE",
  "@TASK_END_DATE"
}
local SCOPE_TAGS = {
  [TASK_SCOPE] = {"@TASKS"},
  [PROJECT_SCOPE] = {"@TASKS", "@PROJECT"},
  [DAY_SCOPE] = {"@TASKS", "@DAY", "@MONTH", "@YEAR"}
}

-- Data
local scope = PROJECT_SCOPE -- Default scope

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
  local tags_text = get_tags_text(SCOPE_TAGS[scope])
  self:getById("template-format-tags"):setValue("Text", tags_text)
end

local apply_changes = function(self, storage)

end

-- Public window creation method
return function(storage)
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
        Text = "",
      },
      ui.Text:new{
        Id = "task-format-tags",
        Width = "auto",
        Class = "caption",
        Style = [[
          margin-bottom: 15;
          font: sans-serif,helvetica,Vera:10;
        ]],
        Text = get_tags_text(TASK_TAGS)
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
        Text = "",
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

  --refresh_according_to_scope(window, scope)
  return window
end
