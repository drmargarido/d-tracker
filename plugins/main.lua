local utils = require "src.utils"

local plugins = {
  require "plugins.theme_switcher.main",
  require "plugins.copy_totals.main"
}

if not utils.is_windows() then
  table.insert(plugins, require "plugins.task_reminder.main")
end

return plugins
