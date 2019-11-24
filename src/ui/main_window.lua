local ui = require "tek.ui"
local List = require "tek.class.list"

local controller = require "src.controller"
local date = require "date.date"

return function()
    -- Prepare data for the display
    local pencil_image = ui.loadImage("images/pencil_icon.PPM")

    local today_tasks = controller.list_tasks(date(), date())

    local tasks_list = {}
    local total_time = nil

    for _, task in ipairs(today_tasks) do
        local start_time = date(task.start_time)
        local end_time = date(task.end_time)
        local duration = date.diff(end_time, start_time)
        table.insert(tasks_list, ui.Text:new{
            Class = "task_data",
            Width = "free",
            Style = [[
                text-align: left;
                margin-left: 5;
            ]],
            Text = string.format(
                "%02d:%02d - %02d:%02d %s",
                start_time:gethours(), start_time:getminutes(),
                end_time:gethours(), end_time:getminutes(),
                task.description
            )
        })
        table.insert(tasks_list, ui.Text:new{
            Class = "project task_data",
            Style = "text-align: left;",
            Text = task.project
        })
        table.insert(tasks_list, ui.Text:new{
            Class = "task_data",
            Style = "text-align: right;",
            Text = string.format(
                "%dh %02dmin",
                duration:gethours(), duration:getminutes()
            )
        })
        table.insert(tasks_list, ui.ImageWidget:new{
            Class = "task_data",
            Height = "fill",
            Width = 30,
            Mode = "button",
            Image = pencil_image,
            onPress = function(self)
                print("hay")
            end
        })

        if not total_time then
            total_time = duration
        else
            total_time = total_time + duration
        end
    end

    local total_time_text
    if total_time then
        total_time_text = string.format(
            "Total Time: %02dh %02dmin",
            total_time:gethours(),
            total_time:getminutes()
        )
    else
        total_time_text = "No records today"
    end

    local current_task = controller.get_task_in_progress()

    local has_task_in_progress = false
    if current_task ~= nil then
        has_task_in_progress = true
    end

    -- Display the window
    return ui.Window:new {
        Title = "D-Tracker",
        Orientation = "vertical",
        Width = 640,
        Height = 480,
        MaxWidth = "none",
        MaxHeight = "none";
        MinWidth = 250,
        MinHeight = 250;
        HideOnEscape = true,
        SizeButton = true,
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
                        Disabled = not has_task_in_progress,
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
            ui.ScrollGroup:new{
                Width = "fill",
                HSliderMode = "auto",
                VSliderMode = "auto",
                Style = "margin-bottom: 20;",
                Child = ui.Canvas:new{
                    AutoWidth = true,
                    AutoHeight = true,
                    Child = ui.Group:new{
                        Class = "task_list",
                        Columns = 4,
                        Orientation = "vertical",
                        Children = tasks_list
                    }
                }
            },
            ui.Group:new{
                Orientation = "horizontal",
                Width = "free",
                Children = {
                    ui.Text:new{
                        Width = 100,
                        Class = "caption",
                        Text = total_time_text
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