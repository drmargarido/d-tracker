local ui = require "tek.ui"

-- Error Validation
local utils = require "src.utils"
local validators = require "src.validators.base_validators"
local is_number = validators.is_number
local is_integer = validators.is_integer
local is_positive = validators.is_positive
local min_length = validators.min_length
local max_length = validators.max_length

-- Error Reporting
local report_error = require "src.ui.utils".report_error

-- Data
local is_active = true
local notify_after = 15

local apply_changes = function(self, storage)
  local minutes = self:getById("reminder_minutes"):getText()
  local length_checks = {min_length(1), max_length(3)}
  local _, err = report_error(utils.validate(length_checks, minutes))
  if err ~= nil then return end

  minutes = tonumber(minutes)
  local value_checks = {is_number, is_integer, is_positive}
  _, err = report_error(utils.validate(value_checks, minutes))
  if err ~= nil then return end

  notify_after = minutes
  storage.data.reminder_is_active = is_active
  storage.data.notify_after = notify_after
  storage:save()

  self:getById("task-reminder-window"):setValue("Status", "hide")
end

return function(storage)
  is_active = storage.data.reminder_is_active
  notify_after = storage.data.notify_after

  return ui.Window:new{
    Title = "Task Reminder",
    Id = "task-reminder-window",
    Status = "hide",
    Style = "margin: 15;",
    Orientation = "vertical",
    Width = "auto",
    Height = "auto",
    Children = {
      ui.Group:new{
        Orientation = "horizontal",
        Children = {
          ui.Text:new{
            Width = 240,
            Text = "Reminder Is Active: ",
            Class = "caption label",
            Style = [[
              font: 14/b;
            ]],
          },
          ui.CheckMark:new{
            Selected = is_active,
            onSelect = function(self)
              is_active = self.Selected
            end
          }
        }
      },
      ui.Group:new{
        Orientation = "horizontal",
        Children = {
          ui.Text:new{
            Width = 240,
            Text = "Notify Every(minutes): ",
            Class = "caption label",
            Style = [[
              font: 14/b;
            ]],
          },
          ui.Input:new{
            Id = "reminder_minutes",
            Width = 30,
            Text = string.format("%d", notify_after),
          },
        }
      },
      ui.Button:new{
        Text = "Apply",
        HAlign = "center",
        Style = "margin-top: 10;",
        onClick = function(self)
          apply_changes(self, storage)
        end
      }
    }
  }
end
