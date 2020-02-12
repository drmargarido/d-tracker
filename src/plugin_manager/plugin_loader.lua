local event_manager = require "src.plugin_manager.event_manager"

-- Registers the plugins event listeners
return function(plugins)
    for _, plugin in ipairs(plugins or {}) do
        for event, callback in pairs(plugin.event_listeners) do
            event_manager.register_listener(event, callback)
        end
    end
end
