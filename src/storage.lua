local conf = require "src.conf"
local utils = require "src.utils"

--[[
    Storage provides a standard place to hold data which
    will be persisted to the filesystem.

    NOTE: Do not use for big quantities of data.
]]

local function exportstring( s )
    return string.format("%q", s)
end

local storage = { data={} }

function storage.init(self)
    -- Use the storage empty
    if not utils.file_exists(conf.storage_path) then
        return
    end

    self.data = dofile(conf.storage_path)
end

-- Based on http://lua-users.org/wiki/SaveTableToFile
function storage.save(self)
    local charS,charE = "   ","\n"
    local file,err = io.open(conf.storage_path, "w")
    if err then
        print("Failed to persist the storage")
        return false, err
    end

    -- initiate variables for save procedure
    local tables,lookup = { self.data },{ [self.data] = 1 }
    file:write("return ")

    for idx,t in ipairs( tables ) do
        if idx > 1 then
            file:write( ","..charE )
        end

        file:write( "{"..charE )
        local thandled = {}

        for i,v in ipairs( t ) do
            thandled[i] = true
            local stype = type( v )

            -- only handle value
            if stype == "table" then
                if not lookup[v] then
                    table.insert( tables, v )
                    lookup[v] = #tables
                end
                file:write( charS.."{"..lookup[v].."},"..charE )
            elseif stype == "string" then
                file:write(  charS..exportstring( v )..","..charE )
            elseif stype == "number" then
                file:write(  charS..tostring( v )..","..charE )
            end
        end

        for i,v in pairs( t ) do
            -- escape handled values
            if (not thandled[i]) then

                local str = ""
                local stype = type( i )
                -- handle index
                if stype == "table" then
                    if not lookup[i] then
                        table.insert( tables,i )
                        lookup[i] = #tables
                    end
                    str = charS.."[{"..lookup[i].."}]="
                elseif stype == "string" then
                    str = charS.."["..exportstring( i ).."]="
                elseif stype == "number" then
                    str = charS.."["..tostring( i ).."]="
                end

                if str ~= "" then
                    stype = type( v )

                    -- handle value
                    if stype == "table" then
                        if not lookup[v] then
                            table.insert( tables,v )
                            lookup[v] = #tables
                        end
                        file:write( str.."{"..lookup[v].."},"..charE )
                    elseif stype == "string" then
                        file:write( str..exportstring( v )..","..charE )
                    elseif stype == "number" or stype == "boolean" then
                        file:write( str..tostring( v )..","..charE )
                    end
                end
            end
        end
        file:write( "}" )
    end
    file:close()

    return true, nil
end

storage:init()
return storage
