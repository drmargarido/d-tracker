local event_manager = require "src.plugin_manager.event_manager"
local plugins = require "plugins.main"

return function()
    for _, plugin in ipairs(plugins) do
        plugin.init()

        for event, callback in pairs(plugin.event_listeners) do
            event_manager.register_listener(event, callback)
        end
    end
end
