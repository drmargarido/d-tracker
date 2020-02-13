local notification_window = require "src.ui.windows.notification_window"
local RESTART_MESSAGE = "Please restart the application to reload the changes."

return function(storage_folder, new_theme)
    -- Change default theme
    local f = io.open(storage_folder.."active_theme.lua", "w")
    if not f then
        print("Failed to edit the active_theme file")
        return false, "Failed to edit the active_theme file"
    end

    f:write(string.format("return \"%s\"", new_theme))
    f:close()

    -- Tell the user to restart the application
    notification_window.display(RESTART_MESSAGE)
    return true, nil
end
