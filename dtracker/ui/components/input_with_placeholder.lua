local ui = require "tek.ui"
local InputWithPlaceholder = {}

function InputWithPlaceholder.new(_, self)
	self = self or {}
    self.Text = self.Text or ""
    self.Placeholder = self.Placeholder or ""

    if #self.Text == 0 and #self.Placeholder ~= 0 then
        self.Class = "placeholder"
        self.Text = self.Placeholder
    end

    local input = ui.Input:new(self)

    -- The widget that really olds the text is the grandson of the input
    local _onSelect = input.Child.Child.onSelect
    input.Child.Child.onSelect = function(_self)
        _onSelect(_self)

        if _self.Selected  then
            if input.Class == "placeholder" then
                input:setValue("Text", "")
                _self:setValue("Class", "")
            end
        else
            if #input:getText() == 0 then
                input:setValue("Text", input.Placeholder)
                _self:setValue("Class", "placeholder")
            end
        end
    end

    return input
end

function InputWithPlaceholder.reset(input)
    input:setValue("Text", input.Placeholder)
    input:setValue("Class", "placeholder")
    input.Child.Child:setValue("Class", "placeholder")
    input:onSetText()
end

return InputWithPlaceholder
