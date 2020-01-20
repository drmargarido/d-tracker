local date = require "date.date"
local list_tasks = require "src.controller.list_tasks"

return function()
    local now = date()
    local today = date(now:getyear(), now:getmonth(), now:getday(), 0, 0, 0)
    local tomorrow = date(today):adddays(1)
    return list_tasks(today, tomorrow)
end
