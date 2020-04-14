-- UI
local ui = require "tek.ui"
local List = require "tek.class.list"

-- Error reporting
local report_error = require "src.ui.utils".report_error

-- Themes
local themes = require "src.themes"
local switch_theme = require "plugins.theme_switcher.switch_theme"

return function(current_theme)
    local themes_names = {}
    for theme, _ in pairs(themes) do
        table.insert(themes_names, {{theme}})
    end

    return ui.Window:new{
        Title = "Theme Select",
        Id = "theme-select-window",
        Status = "hide",
        Style = "margin: 15;",
        Orientation = "vertical",
        Width = "auto",
        Height = "auto",
        Children = {
            ui.Group:new{
                Orientation = "horizontal",
                Children = {
                    ui.Text:new{
                        Width = 150,
                        Text = "Select Theme: ",
                        Class = "caption label",
                        Style = [[
                            font: 14/b;
                        ]],
                    },
                    ui.PopList:new{
                        Id = "theme-switcher-combo",
                        Text = current_theme,
                        Width = "free",
                        ListObject = List:new{
                            Items = themes_names
                        },
                        onSelect = function(self)
                            ui.PopList.onSelect(self)
                            local item = self.ListObject:getItem(self.SelectedLine)
                            if item then
                                local combo = self:getById("theme-switcher-combo")
                                combo:setValue("Text", item[1][1])
                                report_error(switch_theme(item[1][1]))
                            end
                        end,
                    }
                }
            }
        }
    }
end
