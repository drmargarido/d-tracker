-- Error Reporting
local report_error = require "src.ui.utils".report_error

-- Tasks formatter
local formatter = require "plugins.copy_totals.formatter"

-- Input validation
local validators = require "src.validators.base_validators"

-- Clipboard
local clipboard = require "lclipboard"

-- Date
local date = require "date.date"

return function(self)
  if self.Pressed then
    -- Grab the input from the tasks filtering input fields
    local start_input = self:getById("range_start_date")
    local start_text = string.format("%sT00:00:00", start_input:getText())
    local _, err = report_error(validators.is_iso8601(start_text))
    if err ~= nil then
      print(err)
      return
    end
    local start_date = date(start_text)

    local end_input = self:getById("range_end_date")
    local end_text = string.format("%sT00:00:00", end_input:getText())
    _, err = report_error(validators.is_iso8601(end_text))
    if err ~= nil then
      print(err)
      return
    end
    local end_date = date(end_text)
    end_date = date(
      end_date:getyear(), end_date:getmonth(), end_date:getday(), 23, 59, 59
    )

    local search_input = self:getById("stats_text_search")
    local description = search_input:getText()
    if search_input.Class == "placeholder" and description == search_input.Placeholder then
      -- Clear the text if its only the placeholder text
      description = ""
    end

    -- Get the tasks with the wanted format
    local text = formatter(start_date, end_date, description)

    -- Put the formatted tasks text in the clipboard
    clipboard.set_text(text)
  end
end
