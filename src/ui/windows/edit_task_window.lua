-- UI
local ui = require "tek.ui"

-- Validators
local validators = require "src.validators.base_validators"

-- Controllers
local get_task = require "src.controller.get_task"
local stop_task = require "src.controller.stop_task"
local delete_task = require "src.controller.delete_task"
local edit_task_time = require "src.controller.edit_task_time"
local edit_task_project = require "src.controller.edit_task_project"
local edit_task_description = require "src.controller.edit_task_description"
local get_task_in_progress = require "src.controller.get_task_in_progress"
local set_task_in_progress = require "src.controller.set_task_in_progress"

-- Utils
local date = require "date.date"
local ui_utils = require "src.ui.utils"

-- Constats
local row_space = 5

return {
    set_task_to_edit = function(self, task_id, refresh)
        local task, _ = ui_utils.report_error(get_task(task_id))
        local task_in_progress, _ = get_task_in_progress()

        local in_progress = false
        if task_in_progress and task.id == task_in_progress.id then
            in_progress = true
        end

        local start_time = date(task.start_time)
        local end_time = date(task.end_time)

        self:getById("edit_start_date"):setValue("Text", string.format(
            "%04d/%02d/%02d",
            start_time:getyear(),
            start_time:getmonth(),
            start_time:getday()
        ))
        self:getById("edit_start_date"):onSetText()

        self:getById("edit_start_time"):setValue("Text", string.format(
            "%02d:%02d",
            start_time:gethours(),
            start_time:getminutes()
        ))
        self:getById("edit_start_time"):onSetText()

        self:getById("edit_end_date"):setValue("Text", string.format(
            "%04d/%02d/%02d",
            end_time:getyear(),
            end_time:getmonth(),
            end_time:getday()
        ))
        self:getById("edit_end_date"):onSetText()

        self:getById("edit_end_time"):setValue("Text",  string.format(
            "%02d:%02d",
            end_time:gethours(),
            end_time:getminutes()
        ))
        self:getById("edit_end_time"):onSetText()

        self:getById("edit_end_date"):setValue("Disabled", in_progress)
        self:getById("edit_end_time"):setValue("Disabled", in_progress)

        self:getById("edit_description"):setValue("Text", task.description)
        self:getById("edit_description"):onSetText()

        self:getById("edit_project"):setValue("Text", task.project)
        self:getById("edit_project"):onSetText()

        self:getById("edit_in_progress"):setValue("Selected", in_progress)

        self:getById("delete_task_btn"):setValue("onPress", function(_self)
            ui_utils.report_error(delete_task(task_id))
            _self:getById("edit_task_window"):setValue(
                "Status", "hide"
            )
            refresh()
        end)

        self:getById("save_task_btn"):setValue("onPress", function(self)
            -- Read new values from edit fields
            local new_start_date = self:getById("edit_start_date"):getText()
            local new_start_time = self:getById("edit_start_time"):getText()
            local _, err = ui_utils.report_error(
                validators.is_iso8601(
                    string.format("%sT%s:00", new_start_date, new_start_time)
                )
            )
            if err ~= nil then
                print(err)
                return
            end

            local new_start = date(
                string.format("%sT%s:00", new_start_date, new_start_time)
            )

            local new_end_date = self:getById("edit_end_date"):getText()
            local new_end_time = self:getById("edit_end_time"):getText()
            _, err = ui_utils.report_error(
                validators.is_iso8601(
                    string.format("%sT%s:00", new_end_date, new_end_time)
                )
            )
            if err ~= nil then
                print(err)
                return
            end

            local new_end = date(
                string.format("%sT%s:00", new_end_date, new_end_time)
            )

            local new_description = self:getById("edit_description"):getText()
            local new_project = self:getById("edit_project"):getText()

            local new_in_progress = self:getById("edit_in_progress").Selected

            -- Trigger field update when a change is detected
            if new_start ~= start_time and (new_end ~= end_time and not new_in_progress) then
                ui_utils.report_error(edit_task_time(task.id, new_start, new_end))
            elseif new_start ~= start_time then
                ui_utils.report_error(edit_task_time(task.id, new_start, date(task.end_time)))
            elseif new_end ~= end_time and not new_in_progress then
                ui_utils.report_error(edit_task_time(task.id, date(task.start_time), new_end))
            end

            if new_description ~= task.description then
                ui_utils.report_error(edit_task_description(task.id, new_description))
            end

            if new_project ~= task.project then
                ui_utils.report_error(edit_task_project(task.id, new_project))
            end

            if in_progress ~= new_in_progress then
                if new_in_progress then
                    ui_utils.report_error(set_task_in_progress(task.id))
                else
                    ui_utils.report_error(stop_task())
                end
            end

            self:getById("edit_task_window"):setValue(
                "Status", "hide"
            )
            refresh()
        end)
    end,
    init = function()
        return ui.Window:new {
            Title = "Edit Task",
            Id = "edit_task_window",
            Center = true,
            Style = "margin: 15;",
            Status = "hide",
            Orientation = "vertical",
            Width = 400,
            Height = 300,
            Children = {
                ui.Group:new{
                    Width = "free",
                    Height = "auto",
                    Style = "margin-bottom: "..row_space..";",
                    Children = {
                        ui.Text:new{
                            Style = "text-align: left;",
                            Width = 100,
                            Text = "Time:",
                            Class = "caption"
                        },
                        ui.Input:new{
                            Id = "edit_start_date",
                            Width = 76,
                            Text = "27/11/2019"
                        },
                        ui.Area:new{
                            Width = 2,
                            Height = "auto"
                        },
                        ui.Input:new{
                            Id = "edit_start_time",
                            Width = 40,
                            Text = "21:14"
                        },
                        ui.Text:new{
                            Width = 20,
                            Text = "To",
                            Class = "caption"
                        },
                        ui.Input:new{
                            Id = "edit_end_time",
                            Width = 40,
                            Text = "23:14",
                            Disabled = false
                        },
                        ui.Area:new{
                            Width = 2,
                            Height = "auto"
                        },
                        ui.Input:new{
                            Id = "edit_end_date",
                            Width = 76,
                            Text = "27/11/2019",
                            Disabled = false
                        },
                        ui.Area:new{
                            Width = 5,
                            Height = "auto"
                        },
                        ui.CheckMark:new{
                            Id = "edit_in_progress",
                            Text = "In Progress",
                            Selected = false,
                            onSelect = function(self)
                                self:getById("edit_end_date"):setValue("Disabled", self.Selected)
                                self:getById("edit_end_time"):setValue("Disabled", self.Selected)
                            end
                        }
                    }
                },
                ui.Group:new{
                    Width = "free",
                    Height = "auto",
                    Style = "margin-bottom: "..row_space..";",
                    Children = {
                        ui.Text:new{
                            Style = "text-align: left;",
                            Width = 100,
                            Text = "Description:",
                            Class = "caption"
                        },
                        ui.Input:new{
                            Id = "edit_description",
                            Width = "fill"
                        }
                    }
                },
                ui.Group:new{
                    Width = "free",
                    Height = "auto",
                    Style = "margin-bottom: "..(row_space * 2)..";",
                    Children = {
                        ui.Text:new{
                            Style = "text-align: left;",
                            Width = 100,
                            Text = "Project:",
                            Class = "caption"
                        },
                        ui.Input:new{
                            Id = "edit_project",
                            Width = "fill"
                        }
                    }
                },
                ui.Group:new{
                    Width = "free",
                    Height = "auto",
                    Children = {
                        ui.Button:new{
                            Id = "delete_task_btn",
                            Width = 80,
                            Text = "Delete"
                        },
                        ui.Area:new{
                            Width = "free",
                            Height = "auto"
                        },
                        ui.Button:new{
                            Width = 80,
                            Text = "Cancel",
                            onPress = function(self)
                                self:getById("edit_task_window"):setValue(
                                    "Status", "hide"
                                )
                            end
                        },
                        ui.Button:new{
                            Id = "save_task_btn",
                            Width = 80,
                            Text = "Save"
                        }
                    }
                }
            }
        }
    end
}
