local ui = require "tek.ui"
local main_window = require "src.ui.main_window"
local edit_task_window = require "src.ui.edit_task_window"

local function init()
    ui.ThemeName = "d-tracker"
    ui.Application:new{
        Children = {
            main_window(),
            edit_task_window.init()
        }
    }:run()
end

return {
    init=init
}
