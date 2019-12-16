-- Utils
local conf = require "src.conf"
local utils = require "src.utils"

-- Database
local create_database = require "src.create_database"

-- UI
local ui = require "src.ui.ui"

-- Create database if it doesn't exists
if not utils.file_exists(conf.db) then
    create_database()
end

-- Start the UI
ui.init()
