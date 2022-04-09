local date = require "date.date"

-- Plugins
local event_manager = require "src.plugin_manager.event_manager"
local events = require "src.plugin_manager.events"

local csv_template = [[%s]]

local activity_template = [["%s","%s","%d","%s","%s"]]

local csv_escaped_chars = {
    ['"'] = "&quot;",
    ["'"] = "&apos;",
    ["<"] = "&lt;",
    [">"] = "&gt;",
    ["&"] = "&amp;"
}

local escape = function(attribute)
    local escaped_attribute = ""
    for ch in attribute:gmatch(".") do
        if csv_escaped_chars[ch] then
            escaped_attribute=escaped_attribute..csv_escaped_chars[ch]
        else
            escaped_attribute=escaped_attribute..ch
        end
    end

    return escaped_attribute
end

local generate_csv = function(tasks)
    local tasks_activities = ""

    for _, task in ipairs(tasks) do
        local start_time = date(task.start_time)
        local end_time = date(task.end_time)
        local duration = date.diff(end_time, start_time)

        tasks_activities=tasks_activities..string.format(
            activity_template,
            escape(task.project),
            escape(task.description),
            duration:spanminutes(),
            start_time:fmt("%Y-%m-%d %H:%M:%S"),
            end_time:fmt("%Y-%m-%d %H:%M:%S")
        )
    end

    local final_csv = string.format(
        csv_template,
        tasks_activities
    )

    return final_csv
end

local write_csv_to_file = function(tasks, file_path)
    local final_csv = generate_csv(tasks)

    local file = io.open(file_path, "w")
    if file then
        file:write(final_csv)
        file:close()

        event_manager.fire_event(events.CSV_EXPORT, {
            tasks=tasks,
            filename=file_path
        })
        return true, nil
    end

    return false, "Failed to create the csv file "..file_path.." : "..final_csv
end

return {
    write_csv_to_file = write_csv_to_file,
    generate_csv = generate_csv
}

