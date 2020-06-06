--[[
  This plugin fires notifications if the user does not have an active task for
  some time.
]]

-- Events
local events = require "src.plugin_manager.events"

-- UI
local plugin_window = require "plugins.task_reminder.window"

-- Controllers
local get_task_in_progress = require "src.controller.get_task_in_progress"

-- Utils
local utils = require "plugins.utils"

-- Notifications
local notify = require "lnotify"

-- Reminder constant data
local TITLE = "D-Tracker Reminder"
local DESCRIPTION = "No task in progress"

-- Data
local storage = require "src.storage"
local app
local elapsed = 0

return {
  conf = {
    in_menu = true,
    description = "Task Reminder"
  },

  event_listeners = {
    [events.INIT] = function()
      if not storage.data.notify_after then
        storage.data.notify_after = 10
        storage.data.reminder_is_active = true
        storage:save()
      end
    end,

    [events.UI_STARTED] = function(data)
      app = data.app
      local window = plugin_window(storage)
      utils.register_window(app, window)
    end,

    [events.PLUGIN_SELECT] = function(self)
      utils.show_window(self, app, "task-reminder-window")
    end,

    [events.MINUTE_ELAPSED] = function()
      if storage.data.reminder_is_active then
        local task = get_task_in_progress()
        if task then
          elapsed = 0
        else
          elapsed = elapsed + 1
          if elapsed >= storage.data.notify_after then
            notify.send_notification(TITLE, DESCRIPTION)
            elapsed = 0
          end
        end
      end
    end
  }
}
