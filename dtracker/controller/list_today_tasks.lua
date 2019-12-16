local date = require "date.date"
local list_tasks = require "dtracker.controller.list_tasks"

return function()
    local now = date()
    local today = date(now:getyear(), now:getmonth(), now:getday(), 0, 0, 0)
    return list_tasks(today, date(today))
end
