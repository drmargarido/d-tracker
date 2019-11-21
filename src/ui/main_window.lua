local ui = require "tek.ui"
local List = require "tek.class.list"

local controller = require "src.controller"
local date = require "date.date"

return function()
    local today_tasks = controller.list_tasks(date(), date())

    local tasks_list = {}
    local total_time = nil

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

        if not total_time then
            total_time = duration
        else
            total_time = total_time + duration
        end
    end

    return ui.Window:new {
        Title = "D-Tracker",
        Orientation = "vertical",
        Style = "margin: 15;",
        Children = {
            ui.Group:new{
                Width = "free",
                Orientation = "horizontal",
                Style = "margin-bottom: 10;",
                Children = {
                    ui.Text:new{
                        Class = "caption",
                        Text = "No activity",
                        Style = "text-align: left; font: ui-menu:24;/b;"
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
                Width = 120,
                Class = "caption",
                Text = "Start new activity",
                Style = "font: 24/b;"
            },
            ui.Group:new{
                Orientation = "horizontal",
                Style = "margin-bottom: 10;",
                Children = {
                    ui.Input:new{
                        Width = "free"
                    },
                    ui.Button:new{
                        Width = 140,
                        Style = "margin-left: 5;",
                        Text = "Start Tracking",
                        onPress = function(self)
                            print("Yo")
                        end
                    }
                }
            },
            ui.Text:new{
                Width = 60,
                Class = "caption",
                Text = "Today",
                Style = "font: 24/b;"
            },
            ui.ListView:new{
                HSliderMode = "auto",
                Style = "margin-bottom: 20;",
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
            },
            ui.Group:new{
                Orientation = "horizontal",
                Width = "free",
                Children = {
                    ui.Text:new{
                        Width = 100,
                        Class = "caption",
                        Text = string.format(
                            "Total Time: %02dh %02dmin",
                            total_time:gethours(),
                            total_time:getminutes()
                        )
                    },
                    ui.Area:new{
                        Width = "fill",
                        Height = "auto"
                    },
                    ui.Button:new{
                        Width = 180,
                        Text = "Show Overview",
                        onPress = function(self)
                        end
                    }
                }
            }
        }
    }
end