return {
    is_number = function(data)
        if type(data) == "number" then
            return true, nil
        else
            return false, "Received value is not a number"
        end
    end,
    is_text = function(data)
        if type(data) == "string" then
            return true, nil
        else
            return false, "Received value is not a string"
        end
    end,
    --[[
        Here I just search for functions which are expected
        to exist in a date, if they exist I accept the data as
        a valid date.
    ]]
    is_date = function(data)
        if type(data) ~= "table" then
            return false, "The received data is not a date"
        end

        local has_gethours = data.gethours
        local has_getminutes = data.getminutes
        local has_getyear = data.getyear

        if has_getyear and has_gethours and has_getminutes then
            return true, nil
        else
            return false, "The received data is not a date"
        end
    end,
    max_length = function(max_len)
        return function(data)
            if #data > max_len then
                return false, "Text exceeded the max allowed size"
            else
                return true, nil
            end
        end
    end,
    one_of = function(list)
        return function(data)
            for _, element in ipairs(list) do
                if element == data then
                    return true, nil
                end
            end

            return false, "The received element is not part of the allowed ones"
        end
    end
}
