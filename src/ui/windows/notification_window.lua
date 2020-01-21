local ui = require "tek.ui"
local _window

return {
    display = function(message)
        _window:getById("notification_text"):setValue("Text", message)
        _window:setValue("Status", "show")
    end,
    init = function()
        _window = ui.Window:new {
            Title = "Error Notification",
            Id = "notification_window",
            Center = true,
            Style = "margin: 15;",
            Status = "hide",
            Orientation = "vertical",
            Width = "auto",
            Children = {
                ui.Text:new{
                    Id = "notification_text",
                    HAlign = "center",
                    Class = "caption",
                    Text = ""
                },
                ui.Button:new{
                    Width = 150,
                    HAlign = "center",
                    Text = "Close",
                    onPress = function(self)
                        self:getById("notification_window"):setValue(
                            "Status", "hide"
                        )
                    end
                }
            }
        }

        return _window
    end
}
