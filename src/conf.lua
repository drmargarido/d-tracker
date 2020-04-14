local utils = require "src.utils"
local themes = require "src.themes"

local THEME = "default"

local storage_path
local images_folder
local pencil_icon
local app_image

if utils.is_windows() then
    storage_path = ".\\storage_data.lua"
    images_folder = ".\\images"
    pencil_icon = images_folder.."\\"..themes[THEME].pencil_icon
    app_image = images_folder.."\\d-tracker_128x128.ppm"
else
    storage_path = "./storage_data.lua"
    images_folder = "./images"
    pencil_icon = images_folder.."/"..themes[THEME].pencil_icon
    app_image = images_folder.."/d-tracker_128x128.ppm"
end

return {
    db = "d-tracker.sqlite3",
    storage_path = storage_path,
    images_folder = images_folder,

    current_theme = THEME,
    theme = themes[THEME].name,
    pencil_icon = pencil_icon,
    app_image = app_image
}
