local date = require "date.date"

-- Plugins
local event_manager = require "src.plugin_manager.event_manager"
local events = require "src.plugin_manager.events"

local xml_template = [[<?xml version="1.0" ?>
<activities>
    %s
</activities>
]]

local activity_template = [[
    <activity
        category="%s"
        name="%s"
        duration_minutes="%d"
        start_time="%s"
        end_time="%s"
    />
]]

local xml_escaped_chars = {
    ['"'] = "&quot;",
    ["'"] = "&apos;",
    ["<"] = "&lt;",
    [">"] = "&gt;",
    ["&"] = "&amp;"
}

local escape = function(attribute)
    local escaped_attribute = ""
    for ch in attribute:gmatch(".") do
        if xml_escaped_chars[ch] then
            escaped_attribute=escaped_attribute..xml_escaped_chars[ch]
        else
            escaped_attribute=escaped_attribute..ch
        end
    end

    return escaped_attribute
end

local generate_xml = function(tasks)
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

    local final_xml = string.format(
        xml_template,
        tasks_activities
    )

    return final_xml
end

local write_xml_to_file = function(tasks, file_path)
    local final_xml = generate_xml(tasks)

    local file = io.open(file_path, "w")
    if file then
        file:write(final_xml)
        file:close()

        event_manager.fire_event(events.XML_EXPORT, {
            tasks=tasks,
            filename=file_path
        })
        return true, nil
    end

    return false, "Failed to create the xml file "..file_path.." : "..final_xml
end

return {
    write_xml_to_file = write_xml_to_file,
    generate_xml = generate_xml
}

