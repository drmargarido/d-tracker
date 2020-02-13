-- Tekui
local ui = require "tek.ui"

-- Configuration
local conf = require "src.conf"

-- utils
local utils = require "src.utils"

-- Windows
local main_window = require "src.ui.windows.main_window"
local edit_task_window = require "src.ui.windows.edit_task_window"
local stats_window = require "src.ui.windows.stats_window"
local notification_window = require "src.ui.windows.notification_window"
local about_window = require "src.ui.windows.about_window"

-- Plugins
local event_manager = require "src.plugin_manager.event_manager"
local events = require "src.plugin_manager.events"

local function init(plugins)
    ui.ThemeName = conf.theme
    local display = ui.Display:new{}

    if utils.is_windows() then
        -- Change the font on windows to be legible
        display.Style = "font-main: helvetica,Vera:16;"
    end

    local base_window = main_window.init(plugins or {})
    local application = ui.Application:new{
        Display = display,
        Children = {
            base_window,
            about_window.init(),
            edit_task_window.init(main_window.refresh),
            stats_window.init(main_window.refresh),
            notification_window.init()
        }
    }

    main_window.refresh(base_window)

    -- Notify plugins that the application UI is starting
    event_manager.fire_event(events.UI_STARTED, {app=application})

    application:run()
end

return {
    init=init
}
