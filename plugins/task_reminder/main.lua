--[[
  This plugin fires notifications if the user does not have an active task for
  some time.
]]

-- Events
local events = require "src.plugin_manager.events"

-- UI
local plugin_window = require "plugins.task_reminder.window"

-- Utils
local utils = require "plugins.utils"

-- Notifications
local notify = require "lnotify"

-- Data
local app
local elapsed = 0
local notify_after = 2

return {
  conf = {
    in_menu = true,
    description = "Task Reminder"
  },

  event_listeners = {
    [events.UI_STARTED] = function(data)
      app = data.app
      local window = plugin_window()
      utils.register_window(app, window)
    end,

    [events.PLUGIN_SELECT] = function(self)
      utils.show_window(self, app, "task-reminder-window")
    end,

    [events.MINUTE_ELAPSED] = function()
      print("Minute Elapsed from lua")
      elapsed = elapsed + 1
      if elapsed >= notify_after then
        notify.send_notification("D-Tracker Notification", "Task <b>Started!</b>")
        elapsed = 0
      end
    end

  }
}
