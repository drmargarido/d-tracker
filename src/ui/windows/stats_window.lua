

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
local report_error = require "src.ui.utils".report_error

-- Validators
local validators = require "src.validators.base_validators"

-- Exporters
local xml_export = require "src.exporter.xml"

-- Persistance
local persistance = require "src.persistance"

local main_refresh = nil
local now = date()
local last_start_date = date(
    now:getyear(),
    now:getmonth(),
    now:getday(),
    0,
    0,
    0
)
local last_end_date = date(
    now:getyear(),
    now:getmonth(),
    now:getday(),
    23,
    59,
    59
)
local days_scope = 1
-- Set the start date acording with the defined scope
last_start_date = last_start_date:adddays(-(days_scope - 1))

local last_text = ""

local width = 800
local height = 600

local this_window

local _update
_update = function(self, start_date, end_date, text)
    local r1, r2, r3, r4 = this_window:getRect()

    if r1 and r2 and r3 and r4 then
        width = r3 - r1 + 1
        height = r4 - r2 + 1
    end

    last_start_date = start_date or last_start_date
    last_end_date = end_date or last_end_date
    last_text = text or last_text

    -- Get the new list of tasks
    local filtered_tasks
    if last_text ~= nil and #last_text > 0 then
        local err
        filtered_tasks, err = report_error(list_tasks_by_text(
            last_start_date,
            last_end_date,
            last_text
        ))

        if err ~= nil then
            print(err)
            return
        end
    else
        filtered_tasks = list_tasks(last_start_date, last_end_date)
    end

    -- Prepare the tasks for each day
    local days_tasks = {}
    local days_time = {}
    local days = {}

    local tasks_time = {}
    local projects_time = {}
    for _, task in ipairs(filtered_tasks) do
        local task_duration = date.diff(date(task.end_time), date(task.start_time))

        -- Tasks by Date
        local task_date = date(task.start_time):fmt("%A, %d %B %Y")
        if not days_tasks[task_date] then
            table.insert(days, task_date)
            days_time[task_date] = task_duration
            days_tasks[task_date] = {}
        else
            days_time[task_date] = days_time[task_date] + task_duration
        end
        table.insert(days_tasks[task_date], task)

        -- Time By Project
        local project_text = utils.trim_text(task.project, 95)
        if not projects_time[project_text] then
            projects_time[project_text] = task_duration
        else
            projects_time[project_text] = projects_time[project_text] + task_duration
        end

        -- Time By Task
        local task_text = utils.trim_text(task.description, 95)
        if not tasks_time[task_text] then
            tasks_time[task_text] = task_duration
        else
            tasks_time[task_text] = tasks_time[task_text] + task_duration
        end
    end

    -- Sort totals
    local sorted_projects_time = utils.sort_duration(projects_time)
    local sorted_tasks_time = utils.sort_duration(tasks_time)

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
        local duration_text = string.format(
            "%02dh %02dmin",
            days_time[day]:spanhours(),
            days_time[day]:getminutes()
        )

        task_list_element:addMember(
            ui.Group:new{
                Style=[[
                    padding-top: 3;
                    background-color: background;
                ]],
                Children={
                    ui.Text:new{
                        Text = day,
                        Class = "totals_text",
                        Style = [[
                            font: 12/b;
                            text-align: left;
                        ]]
                    },
                    ui.Text:new{
                        Text = duration_text,
                        Class = "totals_text",
                        Style = [[
                            font: 12/b;
                            text-align: right;
                        ]]
                    }
                }
            }
        )
        for _, task in ipairs(days_tasks[day]) do
            task_list_element:addMember(TaskRow.new(task, function()
                _update(self, last_start_date, last_end_date)
                main_refresh(self)
            end, width - 40))
        end
    end

    for _, task_time in ipairs(sorted_tasks_time) do
        local task, time = task_time.key, task_time.duration
        local text_duration = string.format(
            "%02dh %02dmin",
            time:spanhours(),
            time:getminutes()
        )

        tasks_times_element:addMember(ui.Group:new{
            Children = {
                ui.Text:new{
                    Class = "totals_text",
                    Style = [[
                        text-align: left;
                    ]],
                    Text = task
                },
                ui.Text:new{
                    Class = "totals_text",
                    Style = [[
                        text-align: right;
                    ]],
                    Text = text_duration
                }
            }
        })
    end

    for _, project_time in ipairs(sorted_projects_time) do
        local project, time = project_time.key, project_time.duration
        local text_duration = string.format(
            "%02dh %02dmin",
            time:spanhours(),
            time:getminutes()
        )

        projects_times_element:addMember(ui.Group:new{
            Children = {
                ui.Text:new{
                    Class = "totals_text",
                    Style = [[
                        text-align: left;
                    ]],
                    Text = project
                },
                ui.Text:new{
                    Class = "totals_text",
                    Style = [[
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
            local start_text = last_start_date:fmt("%F")
            local end_text = last_end_date:fmt("%F")

            local location_path
            if start_text == end_text then
                -- If both are the same day just put one day instead of a range
                location_path = last_start_date:fmt("%F")..".xml"
            else
                location_path = last_start_date:fmt("%F").."_"..last_end_date:fmt("%F")..".xml"
            end

            local status, path, select = _self.Application:requestFile{
                Title = "Select the export path",
                SelectText = "save",
                Location = location_path,
                Path = conf.xml_path
            }

            if status == "selected" then
                conf.xml_path = path
                persistance.update_xml_save_path(path)

                local fname = path.. "/" .. select[1]
                report_error(xml_export.write_xml_to_file(filtered_tasks, fname))
            end
        end)
    end)
end

local date_search = function(self)
    if not self.Pressed then
        return
    end

    local start_date = string.format(
        "%sT00:00:00",
        self:getById("range_start_date"):getText()
    )
    local end_date = string.format(
        "%sT00:00:00",
        self:getById("range_end_date"):getText()
    )

    local _, err = report_error(validators.is_iso8601(start_date))
    if err ~= nil then
        print(err)
        return
    end

    _, err = report_error(validators.is_iso8601(end_date))
    if err ~= nil then
        print(err)
        return
    end

    -- Make the end date finish at the end of the day
    local final_end_date = date(end_date)
    final_end_date = date(
        final_end_date:getyear(),
        final_end_date:getmonth(),
        final_end_date:getday(),
        23,
        59,
        59
    )
    local final_start_date = date(start_date)
    local diff = date.diff(final_end_date, final_start_date)
    days_scope = math.ceil(diff:spandays())

    _update(self, final_start_date, final_end_date)
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

local refresh_date_inputs = function(self, s, e)
    local s_input = self:getById("range_start_date")
    local e_input = self:getById("range_end_date")
    local s_text = s:fmt("%Y/%m/%d")
    local e_text = e:fmt("%Y/%m/%d")
    s_input:setValue("Text", s_text)
    e_input:setValue("Text", e_text)
end

local previous_date = function(self)
    if not self.Pressed then
        return
    end

    last_start_date = last_start_date:adddays(-days_scope)
    last_end_date = last_end_date:adddays(-days_scope)

    refresh_date_inputs(self, last_start_date, last_end_date)
    _update(self, last_start_date, last_end_date)
end

local next_date = function(self)
    if not self.Pressed then
        return
    end

    last_start_date = last_start_date:adddays(days_scope)
    last_end_date = last_end_date:adddays(days_scope)

    refresh_date_inputs(self, last_start_date, last_end_date)
    _update(self, last_start_date, last_end_date)
end

-- Exportable Methods
return {
    update = _update,
    init = function(refresh)
        main_refresh = refresh
        this_window = ui.Window:new{
            Id = "stats_window",
            Title = "Tasks Overview",
            Style = "margin: 15;",
            Orientation = "vertical",
            Status = "hide",
            Width = width,
            Height = height,
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
                                ui.Button:new{
                                    Width = 8,
                                    Text = "<",
                                    onPress = previous_date
                                },
                                ui.Input:new{
                                    Id = "range_start_date",
                                    Width = 76,
                                    Text = last_start_date:fmt("%Y/%m/%d")
                                },
                                ui.Text:new{
                                    Width = 20,
                                    Class = "caption",
                                    Text = "-"
                                },
                                ui.Input:new{
                                    Id = "range_end_date",
                                    Width = 76,
                                    Text = last_end_date:fmt("%Y/%m/%d")
                                },
                                ui.Button:new{
                                    Width = 8,
                                    Text = ">",
                                    onPress = next_date
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

        this_window:addInputHandler(ui.MSG_KEYDOWN, this_window, function(self, msg)
            -- Delete Pressed
            if msg[3] == 127 then
                local selected_task = TaskRow.get_selection()
                if selected_task.task_id then
                    report_error(delete_task(selected_task.task_id))
                    refresh()
                    _update(self, last_start_date, last_end_date)
                end
            end
        end)

        return this_window
   end
}
