-- Tekui
local ui = require "tek.ui"

-- Utils
local date = require "date.date"
local utils = require "src.utils"

-- Windows
local edit_task_window = require "src.ui.edit_task_window"

-- Globals
local pencil_image = ui.loadImage("images/pencil_icon.PPM")
local selected_id = nil
local task_counter = 1

-- Local Methods
local id_closure = function(id, func)
    return function(self)
        return func(self, id)
    end
end


local select_list_row = function(self, id)
   -- Clean old selected task style
   if selected_id then
      self:getById("row-"..selected_id):setValue(
         "Style", [[
              border-width: 1;
              border-color: #fff;
         ]]
      )
   end

   -- Mark the now select one as selected
   selected_id = id
   self:getById("row-"..selected_id):setValue(
      "Style", [[
          border-width: 1;
          border-color: #55b;
      ]]
   )
end


-- Exportable Methods
return {
    clear_selection = function()
        selected_id = nil
    end,
    new = function(task)
        local row_number = task_counter
        task_counter = task_counter + 1

        local start_time = date(task.start_time)
        local end_time = date(task.end_time)
        local duration = date.diff(end_time, start_time)

        local duration_text = ""
        if duration:spanhours() > 0 then
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
            end_time_text = ""
        end

        return ui.Group:new{
            Id = "row-"..tostring(row_number),
            Class = "task_row",
            Orientation = "horizontal",
            Style = [[
            border-width: 1;
            border-color: #fff;
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
                    utils.trim_text(task.description, 36)
                    ),
                    onPress = id_closure(row_number, function(self, id)
                        select_list_row(self, id)
                    end)
                },
                ui.Text:new{
                    Id = "project-row-"..tostring(row_number),
                    Class = "project task_data",
                    Style = [[
                        text-align: left;
                        padding-left: 5;
                    ]],
                    Mode = "button",
                    Text = utils.trim_text(task.project, 16),
                    onPress = id_closure(row_number, function(self, id)
                        select_list_row(self, id)
                    end)
                },
                ui.Text:new{
                    Id = "duration-row-"..tostring(row_number),
                    Class = "task_data",
                    Style = "text-align: right;",
                    Width = 70,
                    Mode = "button",
                    Text = duration_text,
                    onPress = id_closure(row_number, function(self, id)
                        select_list_row(self, id)
                    end)
                },
                ui.ImageWidget:new{
                    Id = "edit-row-"..tostring(row_number),
                    Class = "task_data",
                    Height = "fill",
                    Width = 30,
                    Mode = "button",
                    Image = pencil_image,
                    onPress = function(self)
                        edit_task_window.set_task_to_edit(self, task.id)
                        self:getById("edit_task_window"):setValue(
                            "Status", "show"
                        )
                    end
                }
            }
        }
    end
}
