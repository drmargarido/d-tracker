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

    self.onSetChanged = function(_self)
        if _self.Changed and _self.Class == "placeholder" then
            local text = _self:getText()
            if #text < #_self.Placeholder then
                _self:setValue("Text", "")
            else
                local placeholder_letters = {}
                local text_letters = {}
                _self.Placeholder:gsub(".",function(c) table.insert(placeholder_letters,c) end)
                text:gsub(".",function(c) table.insert(text_letters,c) end)

                -- The first different letter found is the new one
                local new_letter
                for i, letter in ipairs(placeholder_letters) do
                    if letter ~= text_letters[i] then
                        new_letter = text_letters[i]
                        break
                    end
                end

                _self:setValue("Text", new_letter)
            end

            --[[
                EditInput is the grandchild of the Input
                 class and is the one holding the text
            ]]
            _self:setValue("Class", "")
            _self.Child.Child:setValue("Class", "")
        end
    end

    self.onSelect = function(_self)
        print("Yo")
    end

    return ui.Input:new(self)
end

function InputWithPlaceholder.reset(input)
    input:setValue("Text", input.Placeholder)
    input:setValue("Class", "placeholder")
    input.Child.Child:setValue("Class", "placeholder")
    input:onSetText()
end

return InputWithPlaceholder
