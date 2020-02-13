local utils = require "src.utils"
local themes = require "src.themes"

local THEME = "default"

local xml_path_file = "xml_save_path"
local xml_path = ""
if utils.file_exists(xml_path_file..".lua") then
    xml_path = require(xml_path_file)
end

local storage_folder
local images_folder
local pencil_icon
local app_image

if utils.is_windows() then
    storage_folder = ".\\"
    images_folder = ".\\images"
    pencil_icon = images_folder.."\\"..themes[THEME].pencil_icon
    app_image = images_folder.."\\d-tracker_128x128.ppm"
else
    storage_folder = "./"
    images_folder = "./images"
    pencil_icon = images_folder.."/"..themes[THEME].pencil_icon
    app_image = images_folder.."/d-tracker_128x128.ppm"
end

return {
    db = "d-tracker.sqlite3",
    storage_folder = storage_folder,
    images_folder = images_folder,

    xml_path_file = xml_path_file,
    xml_path = xml_path,

    current_theme = THEME,
    theme = themes[THEME].name,
    pencil_icon = pencil_icon,
    app_image = app_image
}
