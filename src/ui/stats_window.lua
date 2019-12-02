-- Tekui
local ui = require "tek.ui"

-- Controller
local controller = require "src.controller"

-- Components
local TaskRow = require "src.ui.components.task_row"

-- Exportable Methods
return {
    init = function(start_date, end_date)
        local filtered_tasks = controller.list_tasks(start_date, end_date)

        local tasks_list = {}
        for _, task in ipairs(filtered_tasks) do
        table.insert(tasks_list, TaskRow.new(task))
        end

        return ui.Window:new{
            Title = "Time Record",
            Style = "margin: 15;",
            Orientation = "vertical",
            Status = "hide",
            Children = {
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
            }
        }
   end
}
