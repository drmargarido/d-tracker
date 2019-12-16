-- Tekui
local ui = require "tek.ui"

-- Windows
local main_window = require "src.ui.windows.main_window"
local edit_task_window = require "src.ui.windows.edit_task_window"
local stats_window = require "src.ui.windows.stats_window"
local notification_window = require "src.ui.windows.notification_window"

local function init()
    ui.ThemeName = "d-tracker"
    local base_window = main_window.init()
    local application = ui.Application:new{
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
