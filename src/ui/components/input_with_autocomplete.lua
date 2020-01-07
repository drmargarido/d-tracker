local ui = require "tek.ui"

local InputWithPlaceholder = require "src.ui.components.input_with_placeholder"

local count = 1
local ROW_HEIGHT = 26

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

    local input
    if self.Placeholder then
        input = InputWithPlaceholder:new(self)
    else
        input = ui.Input:new(self)
    end

    self.onAutocomplete = self.onAutocomplete or function(_self, text)
        _self:setValue("Text", text)
    end

    input.toggleActiveLine = function(_self, new_line)
        local lines_group = _self.PopupWindow.Children[1].Child.Child

        -- Unselect all lines
        for _, line in ipairs(lines_group.Children) do
            line:setValue("Selected", true) -- Force redraw of all the lines
            line:setValue("Selected", false)
            line:setValue("Style", [[
                border-color: #fff;
            ]])
        end

        _self.SelectedLine = new_line

        -- Select the selected one
        if _self.PopupWindow and _self.SelectedLine ~= 0 then
            local line = lines_group.Children[_self.SelectedLine]
            line:setValue("Selected", true)
            line:setValue("Style", [[
                border-color: #55b;
            ]])
        end
    end

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
            -- No entries, no need to display the popup
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
                Width = winw - 10,
                Height = "auto",
                Style = [[
                    border-color: #fff;
                ]]
            })
        end

        local Children = {
            ui.ScrollGroup:new{
                Child = ui.Canvas:new{
                    Child = ui.Group:new{
                        Class = "autocomplete_group",
                        Orientation = "vertical",
                        Children = text_entries
                    }
                }
            }
        }

        self.PopupWindow = ui.PopupWindow:new{
            -- window in which the popup cascade is rooted:
            PopupRootWindow = _self.Window.PopupRootWindow or _self.Window,
            -- item in which this popup window is rooted:
            PopupBase = _self.PopupBase or _self,
            Children = Children,
            Orientation = "vertical",
            Left = winx,
            Width = winw,
            Top = winy,
            Height = winh + 2,
            MaxWidth = winw,
            MaxHeight = winh,
            Borderless = true,
            PopupWindow = true,
        }

        local app = _self.Application
        app.connect(self.PopupWindow)

        app:addMember(self.PopupWindow)
        self.PopupWindow:setValue("Status", "show")

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
        if self.PopupWindow then
            self.PopupWindow:setValue("Status", "hide")
            _self.Application:remMember(self.PopupWindow)
        end

        _self.Window.ActivePopup = false
        self.PopupWindow = false
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
                input.toggleActiveLine(self, math.max(self.SelectedLine - 1, 0))
            elseif code == 61459 then -- Down
                input.toggleActiveLine(self, math.min(self.SelectedLine + 1, self.TotalLines))
            elseif code == 13 then -- Enter
                if self.SelectedLine ~= 0 then
                    local lines = self.PopupWindow.Children[1].Child.Child
                    local line_text = lines.Children[self.SelectedLine]
                    self.onAutocomplete(input, line_text.Text)

                    _self:setValue("Selected", false)
                end
            else
                _handleKeyboard(_self, msg)
                _self:setValue("Focus", true)
                _self:setValue("Active", true)

                _self:setValue("Selected", false) -- Trigger onSelect to hide the popup
                _self:setValue("Selected", true) -- Trigger onSelect to show the popup refreshed
            end
        end

        return msg
    end

    return input
end

return InputWithAutocomplete
