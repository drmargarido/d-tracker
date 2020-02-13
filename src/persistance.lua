local conf = require "src.conf"
local utils = require "src.utils"

--[[
    Creates a new file that is valid lua and which will
      return the last used xml path
]]
return {
    update_xml_save_path = function(path)
        local f = io.open(conf.xml_path_file..".lua", "w")
        if not f then
            print("Failed to persist the configuration")
            return false, "Failed to persist the configuration"
        end

        if utils.is_windows() then
            -- Escape the \ characters to work in windows
            local windows_path = ""

            local last_char = ""
            for ch in path:gmatch(".") do
                if last_char == "\\" and ch ~= "\\" then
                    windows_path = windows_path.."\\"
                end

                windows_path = windows_path..ch
                last_char = ch
            end

            path = windows_path
        end

        f:write(string.format("return \"%s\"", path))
        f:close()

        return true, nil
    end
}
