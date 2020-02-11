-- Database
local migrations = require "src.migrations.migrations"

-- UI
local ui = require "src.ui.ui"

-- Create database or update its migrations if needed
migrations()

-- Initialize Plugins
local plugin_loader = require "src.plugin_manager.plugin_loader"
plugin_loader()

-- Start the UI
ui.init()
