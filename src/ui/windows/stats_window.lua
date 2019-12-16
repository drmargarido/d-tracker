-- Tekui
local ui = require "tek.ui"

-- Controllers
local list_tasks = require "src.controller.list_tasks"
local delete_task = require "src.controller.delete_task"
local list_tasks_by_text = require "src.controller.list_tasks_by_text"

-- Components
local TaskRow = require "src.ui.components.task_row"
local InputWithPlaceholder = require "src.ui.components.input_with_placeholder"

-- Utils
local conf = require "src.conf"
local date = require "date.date"
local utils = require "src.utils"
local ui_utils = require "src.ui.utils"

-- Validators
local validators = require "src.validators.base_validators"

-- Exporters
local xml_export = require "src.exporter.xml"

-- Persistance
local persistance = require "src.persistance"

local main_refresh = nil
local last_start_date = date()
local last_end_date = date()

local _update
_update = function(self, start_date, end_date, text)
    last_start_date = start_date
    last_end_date = end_date

    -- Get the new list of tasks
    local filtered_tasks
    if text then
        local err
        filtered_tasks, err = ui_utils.report_error(list_tasks_by_text(
            start_date,
            end_date,
            text
        ))

        if err ~= nil then
            print(err)
            return
        end
    else
        filtered_tasks = list_tasks(start_date, end_date)
    end

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
        local project_text = utils.trim_text(task.project, 95)
        if not projects_time[project_text] then
            projects_time[project_text] = project_duration
        else
            projects_time[project_text] = projects_time[project_text] + project_duration
        end

        -- Time By Task
        local task_duration = date.diff(date(task.end_time), date(task.start_time))
        local task_text = utils.trim_text(task.description, 95)
        if not tasks_time[task_text] then
            tasks_time[task_text] = task_duration
        else
            tasks_time[task_text] = tasks_time[task_text] + task_duration
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

    -- Bind tasks to xml export button
    self:getById("stats_xml_export"):setValue("onPress", function(_self)
        local app = _self.Application
        app:addCoroutine(function()
            local status, path, select = _self.Application:requestFile{
                Title = "Select the export path",
                SelectText = "save",
                Location = start_date:fmt("%F").."_"..end_date:fmt("%F")..".xml",
                Path = conf.xml_path
            }

            if status == "selected" then
                conf.xml_path = path
                persistance.update_xml_save_path(path)

                local fname = path.. "/" .. select[1]
                ui_utils.report_error(xml_export(filtered_tasks, fname))
            end
        end)
    end)
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

local text_search = function(self)
    if not self.Pressed then
        return
    end

    local input_element = self:getById("stats_text_search")
    local text = input_element:getText()

    -- Clear the text if its only the placeholder text
    if input_element.Class == "placeholder" and text == input_element.Placeholder then
        text = ""
    end

    _update(self, last_start_date, last_end_date, text)
end

-- Exportable Methods
return {
    update = _update,
    init = function(refresh)
        main_refresh = refresh
        local window = ui.Window:new{
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
                                    Id = "stats_text_search",
                                    Width = "free",
                                    Placeholder = "Search"
                                },
                                ui.Button:new{
                                    Width = 60,
                                    Text = "Apply",
                                    onPress = text_search
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
                    Id = "stats_xml_export",
                    HAlign = "right",
                    Width = 120,
                    Text = "XML Export"
                }
            }
        }

        window:addInputHandler(ui.MSG_KEYDOWN, window, function(self, msg)
            -- Delete Pressed
            if msg[3] == 127 then
                local selected_task = TaskRow.get_selection()
                if selected_task.task_id then
                    ui_utils.report_error(delete_task(selected_task.task_id))
                    refresh()
                    _update(self, last_start_date, last_end_date)
                end
            end
        end)

        return window
   end
}
