return {
    INIT = 1, -- Configuration loaded, migrations setup, before UI starts
    UI_STARTED = 2, -- Application UI is now up
    CLOSE = 3, -- Application will close now
    TASK_INIT = 4, -- A task was started
    TASK_STOP = 5, -- The current test was stopped
    TASK_EDIT = 6, -- Fields of a task changed
    TASK_DELETE = 7, -- A task was deleted
    XML_EXPORT = 8, -- Tasks were exported to a xml file
    PLUGIN_SELECT = 9 -- The current plugin was selected in the plugins list in the top menu
}
