-- Tekui
local ui = require "tek.ui"

-- Configuration
local conf = require "src.conf"
local version = require "VERSION"

-- Data
local app_image = ui.loadImage(conf.app_image)

return {
    init = function()
        return ui.Window:new{
            Title = "About D-Tracker",
            Id = "about-window",
            Style = "margin: 15;",
            Status = "hide",
            Orientation = "vertical",
            Width = 300,
            Children = {
                ui.ImageWidget:new{
                    Image = app_image,
                    Width = 128
                },
                ui.Group:new{
                    Style = "margin-top: 10;",
                    Orientation = "vertical",
                    Children={
                        ui.Text:new{
                            Text = "Version",
                            Style = "font: ui-menu: 18;/b;",
                            Class = "caption"
                        },
                        ui.Text:new{
                            Text = version,
                            Class = "caption"
                        }
                    }
                },
                ui.Group:new{
                    Style = "margin-top: 20;",
                    Orientation = "vertical",
                    Children={
                        ui.Text:new{
                            Text = "Contributors",
                            Style = "font: ui-menu: 18;/b;",
                            Class = "caption"
                        },
                        ui.Text:new{
                            Text = "drmargarido - https://drmargarido.pt",
                            Class = "caption"
                        }
                    }
                },
                ui.Group:new{
                    Style = "margin-top: 20;",
                    Orientation = "vertical",
                    Children = {
                        ui.Text:new{
                            Text = "Repository",
                            Style = "font: ui-menu: 18;/b;",
                            Class = "caption"
                        },
                        ui.Text:new{
                            Text = "https://github/drmargarido/d-tracker",
                            Class = "caption"
                        }
                    }
                },
                ui.Group:new{
                    Style = "margin-top: 20;",
                    Orientation = "vertical",
                    Children = {
                        ui.Text:new{
                            Text = "Used Libraries",
                            Style = "font: ui-menu: 18;/b;",
                            Class = "caption"
                        },
                        ui.Text:new{
                            Text = "LSqlite - http://lua.sqlite.org/index.cgi/index - MIT",
                            Class = "caption"
                        },
                        ui.Text:new{
                            Text = "Date - https://github.com/Tieske/date - MIT",
                            Class = "caption"
                        },
                        ui.Text:new{
                            Text = "Tekui - http://tekui.neoscientists.org/ - MIT",
                            Class = "caption"
                        },
                        ui.Text:new{
                            Text = "Luajit - https://luajit.org/ - MIT",
                            Class = "caption"
                        }
                    }
                }
            }
        }
    end
}
