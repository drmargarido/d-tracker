local ui = require "tek.ui"

return {
  register_window = function(app, window)
    ui.Application.connect(window)
    app:addMember(window)
  end,

  show_window = function(self, app, id)
    local _, _, x, y = self.Window.Drawable:getAttrs()

    -- Archor to the main window position
    local window = app:getById(id)
    window:setValue("Top", y)
    window:setValue("Left", x)

    -- Display window with the options to select the theme
    window:setValue("Status", "show")
  end
}
