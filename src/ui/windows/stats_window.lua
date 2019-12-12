-- Tekui
local ui = require "tek.ui"

-- Controllers
local list_tasks = require "src.controller.list_tasks"

-- Components
local TaskRow = require "src.ui.components.task_row"
local InputWithPlaceholder = require "src.ui.components.input_with_placeholder"

-- Utils
local date = require "date.date"

-- Exportable Methods
return {
    update = function(self, start_date, end_date)
        -- Get the new list of tasks
        local filtered_tasks = list_tasks(start_date, end_date)

        -- Prepare the tasks for each day
        local days_tasks = {}
        for _, task in ipairs(filtered_tasks) do
            local task_date = date(task.start_time):fmt("%A, %d %B %Y")
            if not days_tasks[task_date] then
                days_tasks[task_date] = {}
            end

            table.insert(days_tasks[task_date], task)
        end

        -- Get UI Widgets
        local task_list_element = self:getById("stats_task_list_group")

        -- Clear old UI data
        while #task_list_element.Children > 0 do
            task_list_element:remMember(task_list_element.Children[1])
        end

        -- Update the UI with new data
        for d, tasks in pairs(days_tasks) do
            task_list_element:addMember(ui.Text:new{
                Text = d,
                Style = [[
                    font: 12/b;
                    text-align: left;
                    border-width: 0;
                ]]
            })
            for _, task in ipairs(tasks) do
                task_list_element:addMember(TaskRow.new(task, function()
                    print("Yo Refresh")
                end))
            end
        end
    end,
    update_range = function()

    end,
    filter = function()

    end,
    init = function()
        return ui.Window:new{
            Id = "stats_window",
            Title = "Tasks Overview",
            Style = "margin: 15;",
            Orientation = "vertical",
            Status = "hide",
            Width = 800,
            Height = 600,
            Children = {
                ui.Group:new{
                    Orientation = "horizontal",
                    Width = "free",
                    Height = "auto",
                    Style = "margin-bottom: 20;",
                    Children = {
                        ui.Group:new{
                            Width = "free",
                            Height = "auto",
                            Orientation = "horizontal",
                            Children = {
                                ui.Text:new{
                                    Class = "caption",
                                    Text = "Date Range",
                                    Width = "auto",
                                    Style = "font: 24/b;"
                                },
                                ui.Input:new{
                                    Width = 76,
                                    Text = "2019/12/12"
                                },
                                ui.Text:new{
                                    Width = 20,
                                    Class = "caption",
                                    Text = "-"
                                },
                                ui.Input:new{
                                    Width = 76,
                                    Text = "2019/12/12"
                                },
                                ui.Button:new{
                                    Width = 60,
                                    Text = "Apply"
                                }
                            }
                        },
                        ui.Group:new{
                            Orientation = "horizontal",
                            Width = "free",
                            Height = "auto",
                            Children = {
                                InputWithPlaceholder:new{
                                    Width = "free",
                                    Placeholder = "Search"
                                },
                                ui.Button:new{
                                    Width = 60,
                                    Text = "Apply"
                                }
                            }
                        }
                    }
                },
                ui.PageGroup:new{
                    PageCaptions = {"_Tasks", "_Totals"},
                    Style = "margin-bottom: 20;",
                    Width = "free",
                    Height = "free",
                    Children = {
                        ui.ScrollGroup:new{
                            Width = "free",
                            Height = "free",
                            HSliderMode = "auto",
                            VSliderMode = "auto",
                            Child = ui.Canvas:new{
                                AutoWidth = true,
                                AutoHeight = true,
                                Child = ui.Group:new{
                                    Id = "stats_task_list_group",
                                    Class = "task_list",
                                    Orientation = "vertical",
                                    Children = {}
                                }
                            }
                        },
                        ui.Group:new{
                            Width = "free",
                            Height = "free"
                        }
                    }
                },
                ui.Button:new{
                    HAlign = "right",
                    Width = 120,
                    Text = "XML Export"
                }
            }
        }
   end
}
