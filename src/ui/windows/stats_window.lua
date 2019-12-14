-- Tekui
local ui = require "tek.ui"

-- Controllers
local list_tasks = require "src.controller.list_tasks"

-- Components
local TaskRow = require "src.ui.components.task_row"
local InputWithPlaceholder = require "src.ui.components.input_with_placeholder"

-- Utils
local date = require "date.date"
local ui_utils = require "src.ui.utils"

-- Validators
local validators = require "src.validators.base_validators"

local main_refresh = nil

local _update
_update = function(self, start_date, end_date)
    -- Get the new list of tasks
    local filtered_tasks = list_tasks(start_date, end_date)

    -- Prepare the tasks for each day
    local days_tasks = {}
    local days = {}

    local tasks_time = {}
    local projects_time = {}
    for _, task in ipairs(filtered_tasks) do
        -- Tasks by Date
        local task_date = date(task.start_time):fmt("%A, %d %B %Y")
        if not days_tasks[task_date] then
            table.insert(days, task_date)
            days_tasks[task_date] = {}
        end
        table.insert(days_tasks[task_date], task)

        -- Time By Project
        local project_duration = date.diff(date(task.end_time), date(task.start_time))
        if not projects_time[task.project] then
            projects_time[task.project] = project_duration
        else
            projects_time[task.project] = projects_time[task.project] + project_duration
        end

        -- Time By Task
        local task_duration = date.diff(date(task.end_time), date(task.start_time))
        if not tasks_time[task.description] then
            tasks_time[task.description] = task_duration
        else
            tasks_time[task.description] = tasks_time[task.description] + task_duration
        end
    end

    -- Get UI Widgets
    local task_list_element = self:getById("stats_task_list_group")
    local tasks_times_element = self:getById("stats_tasks_times")
    local projects_times_element = self:getById("stats_projects_times")

    -- Clear old UI data
    while #task_list_element.Children > 0 do
        task_list_element:remMember(task_list_element.Children[1])
    end

    while #tasks_times_element.Children > 0 do
        tasks_times_element:remMember(tasks_times_element.Children[1])
    end

    while #projects_times_element.Children > 0 do
        projects_times_element:remMember(projects_times_element.Children[1])
    end

    -- Update the UI with new data
    for i=#days, 1, -1 do
        local day = days[i]
        task_list_element:addMember(ui.Text:new{
            Text = day,
            Style = [[
                font: 12/b;
                text-align: left;
                border-width: 0;
            ]]
        })
        for _, task in ipairs(days_tasks[day]) do
            task_list_element:addMember(TaskRow.new(task, function()
                _update(self, start_date, end_date)
                main_refresh(self)
            end))
        end
    end

    for task, time in pairs(tasks_time) do
        local text_duration = string.format(
            "%02dh %02dmin",
            time:spanhours(),
            time:getminutes()
        )

        tasks_times_element:addMember(ui.Group:new{
            Children = {
                ui.Text:new{
                    Style = [[
                        border-width: 0;
                        text-align: left;
                    ]],
                    Text = task
                },
                ui.Text:new{
                    Style = [[
                        border-width: 0;
                        text-align: right;
                    ]],
                    Text = text_duration
                }
            }
        })
    end

    for project, time in pairs(projects_time) do
        local text_duration = string.format(
            "%02dh %02dmin",
            time:spanhours(),
            time:getminutes()
        )

        projects_times_element:addMember(ui.Group:new{
            Children = {
                ui.Text:new{
                    Style = [[
                        border-width: 0;
                        text-align: left;
                    ]],
                    Text = project
                },
                ui.Text:new{
                    Style = [[
                        border-width: 0;
                        text-align: right;
                    ]],
                    Text = text_duration
                }
            }
        })
    end
end

local date_search = function(self)
    local start_date = string.format(
        "%sT00:00:00",
        self:getById("range_start_date"):getText()
    )
    local end_date = string.format(
        "%sT00:00:00",
        self:getById("range_end_date"):getText()
    )

    local _, err = ui_utils.report_error(validators.is_iso8601(start_date))
    if err ~= nil then
        print(err)
        return
    end

    _, err = ui_utils.report_error(validators.is_iso8601(end_date))
    if err ~= nil then
        print(err)
        return
    end

    _update(self, date(start_date), date(end_date))
end

-- Exportable Methods
return {
    update = _update,
    init = function(refresh)
        main_refresh = refresh
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
                                    Id = "range_start_date",
                                    Width = 76,
                                    Text = date():fmt("%Y/%m/%d")
                                },
                                ui.Text:new{
                                    Width = 20,
                                    Class = "caption",
                                    Text = "-"
                                },
                                ui.Input:new{
                                    Id = "range_end_date",
                                    Width = 76,
                                    Text = date():fmt("%Y/%m/%d")
                                },
                                ui.Button:new{
                                    Width = 60,
                                    Text = "Apply",
                                    onPress = date_search
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
                            Height = "free",
                            Orientation = "vertical",
                            Children = {
                                ui.Text:new{
                                    Text = "Projects",
                                    Class = "caption",
                                    Style = [[
                                        font: 24/b;
                                        text-align: left;
                                    ]]
                                },
                                ui.ScrollGroup:new{
                                    Width = "free",
                                    Height = "free",
                                    HSliderMode = "auto",
                                    VSliderMode = "auto",
                                    Child = ui.Canvas:new{
                                        AutoWidth = true,
                                        AutoHeight = true,
                                        Child = ui.Group:new{
                                            Id = "stats_projects_times",
                                            Class = "task_list",
                                            Orientation = "vertical",
                                            Children = {}
                                        }
                                    }
                                },
                                ui.Text:new{
                                    Text = "Tasks",
                                    Class = "caption",
                                    Style = [[
                                        font: 24/b;
                                        text-align: left;
                                    ]]
                                },
                                ui.ScrollGroup:new{
                                    Width = "free",
                                    Height = "free",
                                    HSliderMode = "auto",
                                    VSliderMode = "auto",
                                    Child = ui.Canvas:new{
                                        AutoWidth = true,
                                        AutoHeight = true,
                                        Child = ui.Group:new{
                                            Id = "stats_tasks_times",
                                            Class = "task_list",
                                            Orientation = "vertical",
                                            Children = {}
                                        }
                                    }
                                },
                            }
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
