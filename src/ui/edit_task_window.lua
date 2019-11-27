local ui = require "tek.ui"

local set_task_to_edit = function(task_id)

end

return function()
    return ui.Window:new {
        Title = "D-Tracker",
        Id = "edit_task_window",
        Style = "margin: 15;",
        Status = "show",
        Orientation = "vertical",
        Children = {
           ui.Group:new{
              Width = "auto",
              Height = "auto",
              Children = {
                 ui.Text:new{
                    Text = "Description",
                    Class = "caption"
                 },
                 ui.Input:new{
                    
                 }
              }
           },
           ui.Group:new{
              Width = "auto",
              Height = "auto",
              Children = {
                 ui.Text:new{
                    Text = "Project",
                    Class = "caption"
                 },
                 ui.Input:new{
                    
                 }
              }
           }
        }
    }
end
