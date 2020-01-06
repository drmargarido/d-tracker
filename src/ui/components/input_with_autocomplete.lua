local ui = require "tek.ui"

local count = 1
local ROW_HEIGHT= 26

local InputWithAutocomplete = {}
function InputWithAutocomplete.new(_, self)
    self = self or {}

    self.id = count
    count = count + 1

    self.Width = self.Width or "fill"
    self.SelectedLine = self.SelectedLine or 0
    self.ListHeight = self.ListHeight or false
    self.TotalLines = 0

    self.Callback = self.Callback or function(text)
        print("Configure the autocomplete callback function")
        return {
            "This",
            "Autocomplete",
            "Is",
            "Not",
            "Configured",
            "Yet",
            "!"
        }
    end

    local input = ui.Input:new(self)

    input.Child.Child.calcPopup = function(_self)
        local _, _, x, y = _self.Window.Drawable:getAttrs()
        local w
        local r1, r2, r3, r4 = input:getRect()

        x =	x + r1
        y = y + r4
        w = r3 - r1 + 1

        return x, y, w
    end

    input.beginPopup = function(_self)
        local entries = self.Callback(input:getText())
        self.TotalLines = #entries

        if #entries == 0 then
            print("No entries for displaying the autocomplete")
            return
        end

        local winx, winy, winw = _self:calcPopup()
        local winh = math.min(#entries, 8) * ROW_HEIGHT

        local text_entries = {}
        for _, entry in ipairs(entries) do
            table.insert(text_entries, ui.Text:new{
                Class = "autocomplete_row",
                Mode = "button",
                Text = entry,
                Style = "text-align: left;",
                Width = "auto",
                onPress = function(__self)
                    print("Yo")
                end
            })
        end

        local Children = {
            ui.ScrollGroup:new{
                Child = ui.Canvas:new{
                    Child = ui.Group:new{
                        Id = "autocomplete_group",
                        Class = "autocomplete_group",
                        Orientation = "vertical",
                        Children = text_entries
                    }
                }
            }
        }

        _self.PopupWindow = ui.PopupWindow:new{
            -- window in which the popup cascade is rooted:
            PopupRootWindow = _self.Window.PopupRootWindow or _self.Window,
            -- item in which this popup window is rooted:
            PopupBase = _self.PopupBase or _self,
            Children = Children,
            Orientation = "vertical",
            Left = winx,
            Width = winw,
            Top = winy,
            Height = winh,
            MaxWidth = winw,
            MaxHeight = winh,
            Borderless = true,
            PopupWindow = true,
        }

        local app = _self.Application
        app.connect(_self.PopupWindow)

        app:addMember(_self.PopupWindow)
        _self.PopupWindow:setValue("Status", "show")

        _self.Window:addNotify("Status", "hide", function(__self)
            _self:setValue("Selected", false)
        end)

        Children[1].Clicked = false
        Children[1]:setValue("Focus", true)
        self.SelectedLine = 0

    end

    self.endPopup = function(_self)
        _self:setValue("Focus", false)

        _self:setState()
        if _self.PopupWindow then
            _self.PopupWindow:setValue("Status", "hide")
            _self.Application:remMember(_self.PopupWindow)
        end

        _self.Window.ActivePopup = false
        _self.PopupWindow = false
        _self:setValue("Selected", false)
    end

    local _onSelect = input.Child.Child.onSelect
    input.Child.Child.onSelect = function(_self)
        _onSelect(_self)
        if _self.Selected then
            self.beginPopup(_self)
        else
            self.endPopup(_self)
        end
    end

    local _handleKeyboard = input.Child.Child.handleKeyboard
    input.Child.Child.handleKeyboard = function(_self, msg)
        if msg[2] == ui.MSG_KEYDOWN then
            local code = msg[3]
            if code == 27 then -- ESC
                _self:setValue("Selected", false)
                _self:setValue("Focus", false)
                _self:setValue("Active", false)
                return false
            elseif code == 61458 then -- Up
                self.SelectedLine = math.max(self.SelectedLine - 1, 0)
            elseif code == 61459 then -- Down
                self.SelectedLine = math.min(self.SelectedLine + 1, self.TotalLines)
            elseif code == 13 then -- Enter
                print("ENTER")
            else
                _handleKeyboard(_self, msg)
                _self:setValue("Focus", true)
                _self:setValue("Active", true)

                _self:setValue("Selected", false)
                _self:setValue("Selected", true)
            end
        end

        return msg
    end

    return input
end

return InputWithAutocomplete
