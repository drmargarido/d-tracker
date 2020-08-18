local ui = require "tek.ui"

return function(storage)
  return ui.Window:new{
    Title = "Copy Totals",
    Id = "copy-totals-window",
    Status = "hide",
    Style = "margin: 15;",
    Orientation = "vertical",
    Width = "auto",
    Height = "auto",
    Children = {

    }
  }
end
