local date = require "date.date"

local xml_template = [[
    <?xml version="1.0" ?>
    <activities>
        %s
    </activities>
]]

local activity_template = [[
    <activity
        category="%s"
        name="%s"
        start_time="%s"
        end_time="%s"
    />
]]

return function(tasks, file_path)
    local tasks_activities = ""
    for _, task in ipairs(tasks) do
        tasks_activities=tasks_activities..string.format(
            activity_template,
            task.project,
            task.description,
            date(task.start_time):fmt("%Y-%m-%d %H:%M:%S"),
            date(task.end_time):fmt("%Y-%m-%d %H:%M:%S")
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
