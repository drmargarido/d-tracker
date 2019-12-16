#!/usr/bin/env lua

--	how to retrieve mouse coordinates.
--	see also mousecoord1.lua for another method.

local ui = require "tek.ui"

ui.Application:new { 
	Children = {
		ui.Window:new { 
			
			passMsg = function(self, msg)
				local x, y = self:getMsgFields(msg, "mousexy")
				self:getById("text-coord"):setValue("Text", "x="..x.." y="..y)
				return ui.Window.passMsg(self, msg)
			end,

			Children = { 
				ui.Text:new { Id = "text-coord", Text = "Hallo" }
			}
		}
	}
}:run()

