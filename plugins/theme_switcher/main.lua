-- Events
local events = require "src.plugin_manager.events"

-- UI
local plugin_window = require "plugins.theme_switcher.window"

-- Themes
local themes = require "src.themes"

-- Utils
local utils = require "plugins.utils"

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
            utils.register_window(app, window)
        end,

        [events.PLUGIN_SELECT] = function(self)
          utils.show_window(self, app, "theme-select-window")
        end
    }
}
