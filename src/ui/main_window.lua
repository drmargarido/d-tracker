local ui = require "tek.ui"
local List = require "tek.class.list"

return function()
    return ui.Window:new {
        Title = "Timetracker",
        Orientation = "vertical",
        Children = {
            ui.Group:new{
                Orientation = "horizontal",
                Children = {
                    ui.Text:new{
                        Text = "No activity",
                    },
                    ui.Button:new{
                        Text = "Stop Tracking",
                        onPress = function(self)
                            print("Yo")
                        end
                    }
                }
            },
            ui.Text:new{
                Text = "Start new activity",
            },
            ui.Group:new{
                Orientation = "horizontal",
                Children = {
                    ui.Input:new{},
                    ui.Button:new{
                        Text = "Start Tracking",
                        onPress = function(self)
                            print("Yo")
                        end
                    }
                }
            },
            ui.ListView:new{
                HSliderMode = "auto",
                Child = ui.Lister:new{
                    Id = "the-list",
                    SelectMode = "multi",
                    ListObject = List:new{
                        Items = {
                            { { "AL", "Republika e Shqipërisë", "28.748", "2.831.741", "Tiranë", "Shqip", "99" } },
                            { { "VE", "República Bolivariana de Venezuela", "916.445", "28.833.845", "Caracas", "español", "30" } },
                        }
                    },
                    onSelectLine = function(self)
                        ui.Lister.onSelectLine(self)
                        local line = self:getItem(self.SelectedLine)
                    end,
                }
            }
        }
    }
end