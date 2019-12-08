local date = require "date.date"

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

return function(tasks, file_path)
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

    local file = io.open(file_path, "w")
    file:write(final_xml)
    file:close()
end
