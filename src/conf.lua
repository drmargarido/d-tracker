local utils = require "src.utils"

local xml_path_file = "xml_save_path"

local xml_path = ""
if utils.file_exists(xml_path_file..".lua") then
    xml_path = require(xml_path_file)
end

return {
    db = "d-tracker.sqlite3",

    xml_path_file = xml_path_file,
    xml_path = xml_path,

    pencil_icon = "images/pencil_icon.PPM"
}
