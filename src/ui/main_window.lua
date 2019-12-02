local ui = require "tek.ui"
local List = require "tek.class.list"

local controller = require "src.controller"

local utils = require "src.utils"
local date = require "date.date"

local TaskRow = require "src.ui.components.task_row"


return function()
    -- Prepare data for the display
    local today_tasks = controller.list_today_tasks()

    local tasks_list = {}
    local total_time = nil

    local current_task = controller.get_task_in_progress()

    local has_task_in_progress = false
    if current_task ~= nil then
        has_task_in_progress = true

        local task_in_list = false
        for _, task in ipairs(today_tasks) do
            if task.id == current_task.id then
                task_in_list = true
            end
        end

        if not task_in_list then
            table.insert(today_tasks, current_task)
        end
    end

    for i, task in ipairs(today_tasks) do
        local start_time = date(task.start_time)

        local end_time = date(task.end_time)
        local duration = date.diff(end_time, start_time)

        table.insert(tasks_list, TaskRow.new(task))

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
                        Width = 120,
                        Disabled = not has_task_in_progress,
                        Text = "Stop Tracking",
                        onPress = function(self)
                            controller.stop_task()
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
                        Id = "task-description",
                        Width = "free"
                    },
                    ui.Input:new{
                        Id = "task-project",
                        Width = "free"
                    },
                    ui.Button:new{
                        Width = 120,
                        Style = "margin-left: 5;",
                        Text = "Start Tracking",
                        onPress = function(self)
                           if not self.Pressed then
                              return
                           end

                           local description = self:getById(
                              "task-description"
                           ):getText()

                           local project = self:getById(
                              "task-project"
                           ):getText()

                           controller.add_task(description, project)
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
                       Width = 120,
                       Text = "XML Export",
                       onPress = function(self)
                       end
                    },
                    ui.Button:new{
                        Width = 120,
                        Text = "Show Overview",
                        onPress = function(self)
                        end
                    }
                }
            }
        }
    }
end
