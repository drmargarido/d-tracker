-- Tekui
local ui = require "tek.ui"

-- Windows
local main_window = require "src.ui.main_window"
local edit_task_window = require "src.ui.edit_task_window"
local stats_window = require "src.ui.stats_window"

-- Utils
local date = require "date.date"

local function init()
    ui.ThemeName = "d-tracker"
    local base_window = main_window.init()
    local application = ui.Application:new{
        Children = {
            base_window,
            edit_task_window.init(main_window.refresh),
            stats_window.init(date(), date())
        }
    }
    main_window.refresh(base_window)
    application:run()
end

return {
    init=init
}
