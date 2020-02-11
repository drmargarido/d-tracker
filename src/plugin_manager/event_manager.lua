local event_listeners = {}

return {
    -- Register listener to a specific event type
    register_listener = function(event, callback)
        if event_listeners[event] == nil then
            event_listeners[event] = {callback}
        else
            table.insert(event_listeners[event], callback)
        end
    end,

    -- Fire event to all the event associated listeners
    fire_event = function(event, data)
        for _, callback in ipairs(event_listeners[event]) do
            callback(data)
        end
    end
}
