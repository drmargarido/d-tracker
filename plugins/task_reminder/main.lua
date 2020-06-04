-- Events
local events = require "src.plugin_manager.events"

-- UI
--local plugin_window = require "plugins.task_reminder.window"

-- Utils
local utils = require "plugins.utils"

-- Notifications
local notify = require "lnotify"

-- Data
local app

return {
  conf = {
    in_menu = true,
    description = "Task Reminder"
  },

  event_listeners = {
    [events.UI_STARTED] = function(data)
      notify.send_notification("D-Tracker Warning", "Just <b>Started!</b>")
      --[[
      app = data.app
      local window = plugin_window()
      utils.register_window(app, window)
      ]]
    end,

    [events.PLUGIN_SELECT] = function(self)
      --utils.show_window(self, app, "task-reminder-window")
    end
  }
}
