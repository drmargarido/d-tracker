local ui = require "tek.ui"
local List = require "tek.class.list"

local controller = require "src.controller"
local date = require "date.date"

return function()
    local today_tasks = controller.list_tasks(date(), date())

    local tasks_list = {}
    for _, task in ipairs(today_tasks) do
        local start_time = date(task.start_time)
        local end_time = date(task.end_time)
        local duration = date.diff(end_time, start_time)

        table.insert(tasks_list, {{
            string.format("%02d:%02d", start_time:gethours(), start_time:getminutes()),
            "-",
            string.format("%02d:%02d", end_time:gethours(), end_time:getminutes()),
            task.description,
            task.project,
            string.format("%dh %02dmin", duration:gethours(), duration:getminutes())
        }})
    end

    return ui.Window:new {
        Title = "D-Tracker",
        Orientation = "vertical",
        Children = {
            ui.Group:new{
                Width = "free",
                Orientation = "horizontal",
                Children = {
                    ui.Text:new{
                        Class = "caption",
                        Text = "No activity",
                        Style = "text-align: left; margin-left: 10; font: 24/b;"
                    },
                    ui.Area:new{
                        Width = "fill",
                        Height = "auto"
                    },
                    ui.Button:new{
                        Width = 140,
                        Text = "Stop Tracking",
                        onPress = function(self)
                            print("Yo")
                        end
                    }
                }
            },
            ui.Text:new{
                Width = 160,
                Class = "caption",
                Text = "Start new activity",
            },
            ui.Group:new{
                Orientation = "horizontal",
                Children = {
                    ui.Input:new{
                        Width = "free",
                    },
                    ui.Button:new{
                        Width = 140,
                        Text = "Start Tracking",
                        onPress = function(self)
                            print("Yo")
                        end
                    }
                }
            },
            ui.Text:new{
                Width = 80,
                Class = "caption",
                Text = "Today",
            },
            ui.ListView:new{
                HSliderMode = "auto",
                Child = ui.Lister:new{
                    Id = "the-list",
                    SelectMode = "single",
                    ListObject = List:new{
                        Items = tasks_list
                    },
                    onSelectLine = function(self)
                        ui.Lister.onSelectLine(self)
                        local line = self:getItem(self.SelectedLine)
                    end,
                }
            }
        }
    }
end