local conf = require "dtracker.conf"

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

        f:write(string.format("return \"%s\"", path))
        f:close()

        return true, nil
    end
}
