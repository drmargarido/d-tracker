return {
    -- Trims text and adds '...' in the end of the text if trimmed
    trim_text = function(text, max_chars)
        local trimmed_text = text
        if #text > max_chars then
            trimmed_text = trimmed_text:sub(0, max_chars).."..."
        end

        return trimmed_text
    end
}