return {
    INIT = 1, -- Configuration loaded, migrations setup, before UI starts
    UI_STARTED = 2, -- Application UI is now up
    CLOSE = 3, -- Application will close now
    TASK_CREATED = 4, -- A new task was created
    TASK_INIT = 5, -- A already existing task was put in progress
    TASK_STOP = 6, -- The current test was stopped
    TASK_EDIT = 7, -- Fields of a task changed
    TASK_DELETE = 8, -- A task was deleted
    XML_EXPORT = 9, -- Tasks were exported to a xml file
    PLUGIN_SELECT = 10 -- The current plugin was selected in the plugins list in the top menu
}
