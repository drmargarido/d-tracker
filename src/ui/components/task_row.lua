-- Tekui
local ui = require "tek.ui"

-- Utils
local date = require "date.date"
local utils = require "src.utils"
local conf = require "src.conf"

-- Controllers
local add_task = require "src.controller.add_task"

-- Windows
local edit_task_window = require "src.ui.windows.edit_task_window"

-- Globals
local pencil_image = ui.loadImage(conf.pencil_icon)
local selected_id = nil
local selected_task_id = nil

local task_counter = 1

-- Local Methods
local id_closure = function(id, func)
    return function(self)
        return func(self, id)
    end
end


local select_list_row = function(self, id, task_id)
    -- Clean old selected task style
    if selected_id then
        local old_task = self:getById("row-"..selected_id)
        if old_task then
            old_task:setValue(
                "Style", [[
                    border-width: 1;
                    border-color: background;
                ]]
            )
        end
    end

    -- Mark the now select one as selected
    selected_id = id
    selected_task_id = task_id
    self:getById("row-"..selected_id):setValue(
        "Style", [[
            border-width: 1;
            border-color: select;
        ]]
    )
end


-- Exportable Methods
return {
    clear_selection = function()
        selected_id = nil
        selected_task_id = nil
    end,
    get_selection = function()
        return {
            row_id = selected_id,
            task_id = selected_task_id
        }
    end,
    new = function(task, refresh, width)
        local row_number = task_counter
        task_counter = task_counter + 1

        local start_time = date(task.start_time)
        local end_time = date(task.end_time)
        local duration = date.diff(end_time, start_time)

        local duration_text = ""
        if duration:spanhours() >= 1 then
          duration_text = string.format("%dh ", duration:spanhours())
        end

        duration_text = duration_text..string.format(
            "%02dmin",
            duration:getminutes()
        )

        local task_finished = true
        if not task.end_time then
            task_finished = false
        end

        local end_time_text
        if task_finished then
            end_time_text = string.format(
                "%02d:%02d",
                end_time:gethours(),
                end_time:getminutes()
            )
        else
            end_time_text = "         "
        end

        return ui.Group:new{
            Id = "row-"..tostring(row_number),
            Class = "task_row",
            Orientation = "horizontal",
            Style = [[
            border-width: 1;
            border-color: background;
            ]],
            Children = {
                ui.Text:new{
                    Id = "description-row-"..tostring(row_number),
                    Class = "task_data",
                    Width = "auto",
                    Style = [[
                        text-align: left;
                        padding-left: 5;
                    ]],
                    Mode = "button",
                    Text = string.format(
                        "%02d:%02d - %s %s",
                        start_time:gethours(), start_time:getminutes(),
                        end_time_text,
                        utils.trim_text(task.description, width / 14)
                    ),
                    onPress = id_closure(row_number, function(self, id)
                        select_list_row(self, id, task.id)
                    end),
                    onDblClick = function(self)
                        if self.DblClick then
                            add_task(task.description, task.project)

                            local app = self.Application
                            app:addCoroutine(function()
                                refresh()
                            end)
                        end
                    end
                },
                ui.Text:new{
                    Id = "project-row-"..tostring(row_number),
                    Class = "project task_data",
                    Style = [[
                        text-align: left;
                        padding-left: 5;
                    ]],
                    Mode = "button",
                    Text = utils.trim_text(task.project, width / 40),
                    onPress = id_closure(row_number, function(self, id)
                        select_list_row(self, id, task.id)
                    end),
                    onDblClick = function(self)
                        if self.DblClick then
                            add_task(task.description, task.project)

                            local app = self.Application
                            app:addCoroutine(function()
                                refresh()
                            end)
                        end
                    end
                },
                ui.Text:new{
                    Id = "duration-row-"..tostring(row_number),
                    Class = "task_data",
                    Style = "text-align: right;",
                    Width = 70,
                    Mode = "button",
                    Text = duration_text,
                    onPress = id_closure(row_number, function(self, id)
                        select_list_row(self, id, task.id)
                    end),
                    onDblClick = function(self)
                        if self.DblClick then
                            add_task(task.description, task.project)

                            local app = self.Application
                            app:addCoroutine(function()
                                refresh()
                            end)
                        end
                    end
                },
                ui.ImageWidget:new{
                    Id = "edit-row-"..tostring(row_number),
                    Class = "task_data",
                    Height = "fill",
                    Width = 30,
                    Mode = "button",
                    Image = pencil_image,
                    onPress = function(self)
                        edit_task_window.set_task_to_edit(self, task.id, refresh)

                        local _, _, x, y = self.Window.Drawable:getAttrs()
                        local r1, _, _, r4 = self:getRect()
                        x =	x + r1
                        y = y + r4

                        local edit_window = self:getById("edit_task_window")

                        -- Will anchor to the first position where it is opened
                        edit_window:setValue("Left", x - edit_window.Width)
                        edit_window:setValue("Top", y + edit_window.Height / 2)

                        edit_window:setValue(
                            "Status", "show"
                        )
                    end
                }
            }
        }
    end
}
