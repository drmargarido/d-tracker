local utils = require "src.utils"

local plugins = {}
table.insert(plugins, require "plugins.theme_switcher.main")
if not utils.is_windows then
  table.insert(plugins, require "plugins.task_reminder.main")
end

return plugins
