local ui = require "tek.ui"
local controller = require "src.controller"

local date = require "date.date"

local row_space = 5


return {
   set_task_to_edit = function(self, task_id)
      local task = controller.get_task(task_id)
      local start_time = date(task.start_time)
      local end_time = date(task.end_time)
      
      self:getById("edit_start_date"):setValue("Text", string.format(
          "%02d/%02d/%04d",
          start_time:getday(),
          start_time:getmonth(),
          start_time:getyear()
      ))
      self:getById("edit_start_time"):setValue("Text", string.format(
          "%02d:%02d",
          start_time:gethours(),
          start_time:getminutes()
      ))
      self:getById("edit_end_date"):setValue("Text", string.format(
          "%02d/%02d/%04d",
          end_time:getday(),
          end_time:getmonth(),
          end_time:getyear()
      ))

      self:getById("edit_end_time"):setValue("Text",  string.format(
           "%02d:%02d",
           end_time:gethours(),
           end_time:getminutes()
      ))
      self:getById("edit_description"):setValue("Text", task.description)
      self:getById("edit_project"):setValue("Text", task.project)
      --self:getById("edit_in_progress"):setValue("Text", "")
   end,
   init = function()
      return ui.Window:new {
         Title = "Edit Task",
         Id = "edit_task_window",
         Style = "margin: 15;",
         Status = "hide",
         Orientation = "vertical",
         Width = 400,
         Height = 300,
         Children = {
            ui.Group:new{
               Width = "free",
               Height = "auto",
               Style = "margin-bottom: "..row_space..";",
               Children = {
                  ui.Text:new{
                     Style = "text-align: left;",
                     Width = 100,
                     Text = "Time:",
                     Class = "caption"
                  },
                  ui.Input:new{
                     Id = "edit_start_date",
                     Width = 76,
                     Text = "27/11/2019"
                  },
                  ui.Area:new{
                     Width = 2,
                     Height = "auto"
                  },
                  ui.Input:new{
                     Id = "edit_start_time",
                     Width = 40,
                     Text = "21:14"
                  },
                  ui.Text:new{
                     Width = 20,
                     Text = "To",
                     Class = "caption"
                  },
                  ui.Input:new{
                     Id = "edit_end_time",
                     Width = 40,
                     Text = "23:14"
                  },
                  ui.Area:new{
                     Width = 2,
                     Height = "auto"
                  },
                  ui.Input:new{
                     Id = "edit_end_date",
                     Width = 76,
                     Text = "27/11/2019"
                  },
                  ui.Area:new{
                     Width = 5,
                     Height = "auto"
                  },
                  ui.CheckMark:new{
                     Id = "edit_in_progress",
                     Text = "In Progress",
                     Selected = false,
                     onSelect = function(self)
                     end
                  }
               }
            },
            ui.Group:new{
               Width = "free",
               Height = "auto",
               Style = "margin-bottom: "..row_space..";",
               Children = {
                  ui.Text:new{
                     Style = "text-align: left;",
                     Width = 100,
                     Text = "Description:",
                     Class = "caption"
                  },
                  ui.Input:new{
                     Id = "edit_description",
                     Width = "fill"
                  }
               }
            },
            ui.Group:new{
               Width = "free",
               Height = "auto",
               Style = "margin-bottom: "..(row_space * 2)..";",
               Children = {
                  ui.Text:new{
                     Style = "text-align: left;",
                     Width = 100,
                     Text = "Project:",
                     Class = "caption"
                  },
                  ui.Input:new{
                     Id = "edit_project",
                     Width = "fill"                    
                  }
               }
            },
            ui.Group:new{
               Width = "free",
               Height = "auto",
               Children = {
                  ui.Button:new{
                     Width = 80,
                     Text = "Delete"
                  },
                  ui.Area:new{
                     Width = "free",
                     Height = "auto"                    
                  },
                  ui.Button:new{
                     Width = 80,
                     Text = "Cancel",
                     onPress = function(self)
                        self:getById("edit_task_window"):setValue(
                           "Status", "hide"
                                                                 )
                     end
                  },
                  ui.Button:new{
                     Width = 80,
                     Text = "Save"
                  }
               }
            }
         }
      }
   end
}
