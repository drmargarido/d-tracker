return {
    -- Trims text and adds '...' in the end of the text if trimmed
    trim_text = function(text, max_chars)
        local trimmed_text = text
        if #text > max_chars then
            trimmed_text = trimmed_text:sub(0, max_chars).."..."
        end

        return trimmed_text
    end,

    -- Tries to rename the file, if it fails the file does not exist
    file_exists = function (name)
        if type(name) ~= "string" then
            return false
        end

        return os.rename(name,name) and true or false
    end,

    -- Checks if the table contains an entry with the key
    get_keys = function(_table)
        local keys = {}

        for k, _ in pairs(_table) do
            table.insert(keys, k)
        end

        return keys
    end
}
