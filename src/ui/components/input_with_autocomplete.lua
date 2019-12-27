local ui = require "tek.ui"
local PopList = ui.require("poplist", 5)
local Input = ui.require("input", 28)
ui.require("widget", 26)

local InputWithAutocomplete = {}

function InputWithAutocomplete.new(class, self)
    self = self or {}
    return Input.new(class, self)
end

return InputWithAutocomplete
