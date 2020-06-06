return {
  INIT = 1, -- Configuration loaded, migrations setup, before UI starts
  UI_STARTED = 2, -- Application UI is now up
  CLOSE = 3, -- Application will close now
  TASK_CREATED = 4, -- A new task was created
  TASK_STOP = 5, -- The current task was stopped
  TASK_EDIT = 6, -- Fields of a task changed
  TASK_DELETE = 7, -- A task was deleted
  PROJECT_CREATED = 8, -- A new project was created
  XML_EXPORT = 9, -- Tasks were exported to a xml file
  PLUGIN_SELECT = 10, -- The current plugin was selected in the plugins list in the top menubar
  MINUTE_ELAPSED = 11 -- Triggered every minute
}
