-- Utils
local conf = require "dtracker.conf"
local utils = require "dtracker.utils"

-- Database
local create_database = require "dtracker.create_database"

-- UI
local ui = require "dtracker.ui.ui"

-- Create database if it doesn't exists
if not utils.file_exists(conf.db) then
    create_database()
end

-- Start the UI
ui.init()
