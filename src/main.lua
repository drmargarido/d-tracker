-- Database
local migrations = require "src.migrations.migrations"

-- UI
local ui = require "src.ui.ui"

-- Plugins
local plugin_loader = require "src.plugin_manager.plugin_loader"
local event_manager = require "src.plugin_manager.event_manager"
local events = require "src.plugin_manager.events"
local plugins = require "plugins.main"

-- Configuration
local conf = require "src.conf"

-- Create database or update its migrations if needed
migrations()

-- Initialize Plugins
plugin_loader(plugins)
event_manager.fire_event(events.INIT, {conf=conf})

-- Start the UI
ui.init(plugins)
