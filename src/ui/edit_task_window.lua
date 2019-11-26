local ui = require "tek.ui"

return function(task_id)
    return ui.Window:new {
        Title = "D-Tracker",
        Id = "edit_task_window",
        Orientation = "vertical",
        Style = "margin: 15;",
        Status = "show",
        Width = "auto",
        Children = {
            ui.Text:new{
                Text = "Yo"
            }
        }
    }
end