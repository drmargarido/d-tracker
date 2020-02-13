local plugin_loader = require "src.plugin_manager.plugin_loader"
local event_manager = require "src.plugin_manager.event_manager"
local events = require "src.plugin_manager.events"

describe("Plugins Validation", function()
    it("Registers a plugin", function()
        local test_passed = false

        local mock_plugin = {
            conf = {
                in_menu = false,
                description = "Mock"
            },
            event_listeners = {
                [events.PLUGIN_SELECT] = function()
                    test_passed = true
                end
            }
        }

        plugin_loader({mock_plugin})
        event_manager.fire_event(events.PLUGIN_SELECT, {})

        assert.is_true(test_passed)
    end)

    it("Fires an event" , function()
        local test_passed = false
        event_manager.fire_event(events.PLUGIN_SELECT, {})
        assert.is_false(test_passed)

        local mock_plugin = {
            conf = {
                in_menu = false,
                description = "Mock"
            },
            event_listeners = {
                [events.PLUGIN_SELECT] = function()
                    test_passed = true
                end
            }
        }

        plugin_loader({mock_plugin})
        event_manager.fire_event(events.PLUGIN_SELECT, {})
        assert.is_true(test_passed)
    end)
end)
