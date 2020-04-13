local utils = require "src.utils"
local themes = require "src.themes"

local lfs = require "lfs"

local THEME = "default"

--[[
    Create the folder $(HOME)/.local/share/d-tracker
    if it does not exists
]]
local home = os.getenv("HOME")
local local_folder = home.."/.local"
if not utils.file_exists(local_folder) then
    lfs.mkdir(local_folder)
end

local share_folder = local_folder.."/share"
if not utils.file_exists(share_folder) then
    lfs.mkdir(share_folder)
end

local dtracker_folder = share_folder.."/d-tracker"
if not utils.file_exists(dtracker_folder) then
    lfs.mkdir(dtracker_folder)
end

local storage_path = dtracker_folder.."/storage_data.lua"
local images_folder = "/usr/share/d-tracker/images"

return {
    db = dtracker_folder.."/d-tracker.sqlite3",
    storage_path = storage_path,
    images_folder = images_folder,

    current_theme = THEME,
    theme = themes[THEME].name,
    pencil_icon = images_folder.."/"..themes[THEME].pencil_icon,
    app_image = images_folder.."/d-tracker_128x128.ppm"
}
