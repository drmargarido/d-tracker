--[[
  This plugins allows the copy of the totals of the tasks in the show overview
  window to the clipboard in a formatted way.
]]

-- Events
local events = require "src.plugin_manager.events"

-- UI
local ui = require "tek.ui"
local plugin_window = require "plugins.copy_totals.window"

-- Utils
local utils = require "plugins.utils"

-- Clipboard
local clipboard = require "lclipboard"
local tasks_to_clipboard = require "plugins.copy_totals.tasks_to_clipboard"

-- Scopes
local scopes = require "plugins.copy_totals.scopes"

-- Data
local storage = require "src.storage"
local app

return {
  conf = {
    in_menu = true,
    description = "Copy Totals"
  },

  event_listeners = {
    [events.INIT] = function()
      clipboard.init()

      -- Make sure copy_totals configuration exist in storage
      if not storage.data.copy_scope then
        storage.data.copy_scope = scopes.PROJECT_SCOPE
        storage.data.task_format = [[  + @TASK_DESCRIPTION]]
        storage.data.template_format = [[+ @PROJECT
@TASKS
]]
        storage:save()
      end
    end,

    [events.UI_STARTED] = function(data)
      -- Create plugin configuration window
      app = data.app
      local window = plugin_window(storage)
      utils.register_window(app, window)

      -- Inject copy to clipboard button in the show overview totals
      local topbar = app:getById("projects-totals-top-bar")
      topbar:addMember(ui.Button:new{
        HAlign = "right",
        Width = 20,
        Text = "⊙",
        onPress = function(self)
          if self.Pressed then
            tasks_to_clipboard(self, storage)
          end
        end
      })
    end,

    [events.PLUGIN_SELECT] = function(self)
      utils.show_window(self, app, "copy-totals-window")
    end,

    [events.CLOSE] = function()
      clipboard.close()
    end
  }
}
