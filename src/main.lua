-- Database
local migrations = require "src.migrations.migrations"

-- UI
local ui = require "src.ui.ui"

-- Create database or update its migrations if needed
migrations()

-- Start the UI
ui.init()
