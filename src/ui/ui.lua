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
    ui.Application:new{
        Children = {
            main_window(),
            edit_task_window.init(),
            stats_window.init(date(), date())
        }
    }:run()
end

return {
    init=init
}
