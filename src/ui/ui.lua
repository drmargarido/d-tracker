local ui = require "tek.ui"
local main_window = require "src.ui.main_window"

local function init()
    ui.ThemeName = "d-tracker"
    ui.Application:new{
        Children = {
            main_window()
        }
    }:run()
end

return {
    init=init
}
