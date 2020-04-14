local storage = require "src.storage"

local notification_window = require "src.ui.windows.notification_window"
local RESTART_MESSAGE = "Please restart the application to reload the changes."

return function(new_theme)
    -- Change default theme
    storage.data.current_theme = new_theme
    storage:save()

    -- Tell the user to restart the application
    notification_window.display(RESTART_MESSAGE)
    return true, nil
end
