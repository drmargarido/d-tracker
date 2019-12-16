#!/usr/bin/env lua

--	how to retrieve mouse coordinates.
--	see also mousecoord2.lua for another method.

local ui = require "tek.ui"

ui.Application:new { 
	Children = {
		ui.Window:new { 
		
			show = function(self)
				ui.Window.show(self)
				self:addInputHandler(ui.MSG_MOUSEMOVE, self, self.getMouse)
			end,
			hide = function(self)
				ui.Window.hide(self)
				self:remInputHandler(ui.MSG_MOUSEMOVE, self, self.getMouse)
			end,
			
			getMouse = function(self, msg)
				local x, y = self:getMsgFields(msg, "mousexy")
				self:getById("text-coord"):setValue("Text", "x="..x.." y="..y)
				return msg
			end,
		
			Children = { 
				ui.Text:new { Id = "text-coord", Text = "Hallo" }
			}
		}
	}
}:run()

