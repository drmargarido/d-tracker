local events = require "src.plugin_manager.events"

return {
    conf = {
        in_menu = true,
        description = "Theme Select"
    },

    event_listeners = {
        [events.INIT] = function(data)
            -- Load last used theme and set it as the current one
        end,

        [events.UI_STARTED] = function(data)
            -- Register the window in the application
        end,

        [events.PLUGIN_SELECT] = function(data)
            -- Display window with the options to select the theme
        end
    }
}
