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

    -- Gets a table with only the keys of the current table
    get_keys = function(_table)
        local keys = {}

        for k, _ in pairs(_table) do
            table.insert(keys, k)
        end

        return keys
    end,

    --[[
        Sorting of tables with duration was not working so here we create a new
        table as a list but with their values(durations) sorted
    ]]
    sort_duration = function(unsorted_table)
        local already_sorted = {}
        local sorted = {}

        for _, _ in pairs(unsorted_table) do
            local max = nil

            for key, duration in pairs(unsorted_table) do
                if not max then
                    if not already_sorted[key] then -- Ignore already sorted entries
                        max = {key=key, duration=duration}
                    end
                else
                    if not already_sorted[key] then -- Ignore already sorted entries
                        if max.duration:spanhours() < duration:spanhours() then
                            max = {key=key, duration=duration}
                        end
                    end
                end
            end

            already_sorted[max.key] = true
            table.insert(sorted, {key=max.key, duration=max.duration})
        end

        return sorted
    end,

    -- Check if the application is running in windows
    is_windows = function()
        return package.config:sub(1,1) == "\\"
    end,

    -- Standard task printing
    print_task = function(task)
        print(string.format(
            "%d|%s|%s|%s|%s",
            task.id,
            task.project,
            task.start_time,
            task.end_time or "---",
            task.description
        ))
    end
}
