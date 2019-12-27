-- Controllers
local add_task = require "src.controller.add_task"
local stop_task = require "src.controller.stop_task"
local delete_task = require "src.controller.delete_task"
local list_today_tasks = require "src.controller.list_today_tasks"
local get_task_in_progress = require "src.controller.get_task_in_progress"

-- Exporters
local xml_export = require "src.exporter.xml"

-- Settings
local conf = require "src.conf"
local persistance = require "src.persistance"

-- Utils
local date = require "date.date"
local utils = require "src.utils"
local ui_utils = require "src.ui.utils"

-- UI components
local ui = require "tek.ui"
local TaskRow = require "src.ui.components.task_row"
local InputWithPlaceholder = require "src.ui.components.input_with_placeholder"

-- Windows
local stats_window = require "src.ui.windows.stats_window"
local this_window

local _refresh
_refresh = function()
    -- Clear row selection
    TaskRow.clear_selection()

    -- Get UI elements
    local current_activity_element = this_window:getById("current_activity_text")
    local stop_tracking_element = this_window:getById("stop_tracking_button")
    local task_list_group_element = this_window:getById("task_list_group")
    local total_time_element = this_window:getById("total_time_text")

    -- Prepare the updated data
    local today_tasks = list_today_tasks()
    local current_task = get_task_in_progress()

    -- Add current task to the today tasks list if its not there already
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

    local current_activity_text = "No Activity"
    if has_task_in_progress then
        current_activity_text = utils.trim_text(current_task.description, 54)
    end

    -- Calculate total time
    local total_time = nil
    for _, task in ipairs(today_tasks) do
        local start_time = date(task.start_time)

        local end_time = date(task.end_time)
        local duration = date.diff(end_time, start_time)

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
            total_time:spanhours(),
            total_time:getminutes()
        )
    else
        total_time_text = "No records today"
    end

    -- Set the updated data in the UI elements
    local tasks_rows = {}
    for _, task in ipairs(today_tasks) do
        table.insert(tasks_rows, TaskRow.new(task, _refresh))
    end

    current_activity_element:setValue("Text", current_activity_text)
    stop_tracking_element.Disabled = not has_task_in_progress
    total_time_element:setValue("Text", total_time_text)

    -- Configure export xml callback
    this_window:getById("export_xml_btn"):setValue("onPress", function(_self)
        local app = this_window.Application
        app:addCoroutine(function()
            local status, path, select = _self.Application:requestFile{
                Title = "Select the export path",
                SelectText = "save",
                Location = date():fmt("%F")..".xml",
                Path = conf.xml_path
            }

            if status == "selected" then
                conf.xml_path = path
                persistance.update_xml_save_path(path)

                local fname = path .. "/" .. select[1]
                ui_utils.report_error(xml_export(today_tasks, fname))
            end
        end)
    end)

    -- Clear old tasks rows
    while #task_list_group_element.Children > 0 do
        task_list_group_element:remMember(task_list_group_element.Children[1])
    end

    -- Add new tasks rows
    for _, row in ipairs(tasks_rows) do
        task_list_group_element:addMember(row)
    end
end

return {
    -- Update the UI with data according to the current db state
    refresh = _refresh,

    init = function()
        this_window = ui.Window:new {
            Title = "D-Tracker",
            Orientation = "vertical",
            Width = 800,
            Height = 600,
            MaxWidth = "none",
            MaxHeight = "none";
            MinWidth = 250,
            MinHeight = 250;
            HideOnEscape = true,
            SizeButton = true,
            Style = "margin: 15;",
            Id = "main_ui_window",
            Children = {
                ui.Group:new{
                    Width = "free",
                    Orientation = "horizontal",
                    Style = "margin-bottom: 10;",
                    Children = {
                        ui.Text:new{
                            Id = "current_activity_text",
                            Class = "caption",
                            Text = "No Activity",
                            Style = "text-align: left; font: ui-menu:24;/b;"
                        },
                        ui.Area:new{
                            Width = "fill",
                            Height = "auto"
                        },
                        ui.Button:new{
                            Id = "stop_tracking_button",
                            Width = 120,
                            Disabled = true,
                            Text = "Stop Tracking",
                            onPress = function(self)
                                if not self.Pressed then
                                    return
                                end

                                ui_utils.report_error(stop_task())
                                _refresh()
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
                ui.PopItem:new{
                    Text = "Test",
                    Children = {
                        ui.Text:new{
                            Text = "Last Task"
                        },
                        ui.Text:new{
                            Text = "Other Task"
                        }
                    }
                },
                ui.Group:new{
                    Orientation = "horizontal",
                    Style = "margin-bottom: 10;",
                    Children = {
                        InputWithPlaceholder:new{
                            Id = "task-description",
                            Width = "free",
                            MinWidth = 240,
                            Placeholder = "Description"
                        },
                        InputWithPlaceholder:new{
                            Id = "task-project",
                            Width = "free",
                            Placeholder = "Project"
                        },
                        ui.Button:new{
                            Width = 120,
                            Style = "margin-left: 5;",
                            Text = "Start Tracking",
                            onPress = function(self)
                                if not self.Pressed then
                                    return
                                end

                                local description_element = self:getById("task-description")
                                local description = description_element:getText()

                                local project_element = self:getById("task-project")
                                local project = project_element:getText()

                                ui_utils.report_error(add_task(description, project))

                                -- Clear inputs and refresh UI

                                InputWithPlaceholder.reset(description_element)
                                InputWithPlaceholder.reset(project_element)

                                _refresh()
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
                    --HSliderMode = "auto",
                    VSliderMode = "auto",
                    Style = "margin-bottom: 20;",
                    Child = ui.Canvas:new{
                        AutoWidth = true,
                        AutoHeight = true,
                        Child = ui.Group:new{
                            Id = "task_list_group",
                            Class = "task_list",
                            Orientation = "vertical",
                            Children = {}
                        }
                    }
                },
                ui.Group:new{
                    Orientation = "horizontal",
                    Width = "free",
                    Children = {
                        ui.Text:new{
                            Id = "total_time_text",
                            Width = 100,
                            Class = "caption",
                            Text = "No Records Today"
                        },
                        ui.Area:new{
                            Width = "fill",
                            Height = "auto"
                        },
                        ui.Button:new{
                            Id = "export_xml_btn",
                            Width = 120,
                            Text = "XML Export"
                        },
                        ui.Button:new{
                            Width = 120,
                            Text = "Show Overview",
                            onPress = function(self)
                                stats_window.update(self, date(), date())
                                self:getById("stats_window"):setValue("Status", "show")
                            end
                        }
                    }
                }
            }
        }

        this_window:addInputHandler(ui.MSG_KEYDOWN, this_window, function(self, msg)
            -- Delete Pressed
            if msg[3] == 127 then
                local selected_task = TaskRow.get_selection()
                if selected_task.task_id then
                    ui_utils.report_error(delete_task(selected_task.task_id))
                    _refresh()
                end
            end
        end)

        return this_window
    end
}
