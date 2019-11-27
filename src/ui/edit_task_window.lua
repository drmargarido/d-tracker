local ui = require "tek.ui"

local set_task_to_edit = function(task_id)

end

return function()
    return ui.Window:new {
        Title = "D-Tracker",
        Id = "edit_task_window",
        Orientation = "vertical",
        Style = "margin: 15;",
        Status = "hide",
        Width = "auto",
        Children = {
            ui.Group:new{
                Width = "auto",
                ui.Text:new{
		    Width = 100,
                    Text = "Description"
                },
		ui.Input:new{
                }
            },
            ui.Group:new{
	        Width = "free",
                ui.Text:new{
		    Width = 100,
                    Text = "Project"
                },
		ui.Input:new{
                }
            }
        }
    }
end