-- Events
local events = require "src.plugin_manager.events"

-- UI
local ui = require "tek.ui"
local plugin_window = require "plugins.theme_switcher.window"

-- Utils
local utils = require "src.utils"

-- Themes
local themes = require "src.themes"

-- Data
local storage = require "src.storage"
local app

return {
    conf = {
        in_menu = true,
        description = "Theme Select"
    },

    event_listeners = {
        [events.INIT] = function(data)
            -- Load last used theme and set it as the current one
            if storage.data.current_theme then
                local current_theme = storage.data.current_theme
                local icon = themes[current_theme].pencil_icon
                local img_folder = data.conf.images_folder
                data.conf.theme = themes[current_theme].name
                data.conf.pencil_icon = img_folder.."/"..icon
            else
                storage.data.current_theme = data.conf.current_theme
                storage:save()
            end
        end,

        [events.UI_STARTED] = function(data)
            -- Register the window in the application
            app = data.app
            local window = plugin_window(storage.data.current_theme)

            ui.Application.connect(window)
            data.app:addMember(window)
        end,

        [events.PLUGIN_SELECT] = function(self)
            local _, _, x, y = self.Window.Drawable:getAttrs()

            -- Archor to the main window position
            local theme_window = app:getById("theme-select-window")
            theme_window:setValue("Top", y)
            theme_window:setValue("Left", x)

            -- Display window with the options to select the theme
            theme_window:setValue("Status", "show")
        end
    }
}
