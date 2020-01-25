-- Tekui
local ui = require "tek.ui"

-- Windows
local main_window = require "src.ui.windows.main_window"
local edit_task_window = require "src.ui.windows.edit_task_window"
local stats_window = require "src.ui.windows.stats_window"
local notification_window = require "src.ui.windows.notification_window"

local function init()
    ui.ThemeName = "d-tracker"
    local display = ui.Display:new{}

    if package.config:sub(1,1) == "\\" then -- Check if its running in Windows
        -- Change the font on windows to be legible
        display.Style = "font-main: helvetica,Vera:16;"
    end

    local base_window = main_window.init()
    local application = ui.Application:new{
        Display = display,
        Children = {
            base_window,
            edit_task_window.init(main_window.refresh),
            stats_window.init(main_window.refresh),
            notification_window.init()
        }
    }

    main_window.refresh(base_window)
    application:run()
end

return {
    init=init
}
