local ui = require "tek.ui"

return function()
  return ui.Window:new{
    Title = "Theme Select",
    Id = "task-reminder-window",
    Status = "hide",
    Style = "margin: 15;",
    Orientation = "vertical",
    Width = "auto",
    Height = "auto",
    Children = {}
  }
end
