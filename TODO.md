# TODO

* Bugfix
    + Fix sometimes fields not rerendering when moving and minimizing the window.
    + Crash happened in the first export of the xml?
    + Fix selection with arrows + shift of text in the input fields
    + Input key is consumed after a special char put in the autocomplete fields

* Implement a command line interface to interact with D-tracker
    + Present help text when no arguments are received
    + Starting of a new task
    + Stop of the running task
    + Listing of the today tasks
    + Listing of the tasks by range of dates
    + Listing of the tasks by text
    + Exporting to XML

* Build releases
    + Macos Binary Release
        - Create an app file
    + DEB package?

* Sugestions
    + Minimize to tray
    + Update the timers of the main window every minute? (Does it matter?)
        1. Coroutine in lua running time counting and triggering the update every minute or thread in C running a refresh method received from lua
        2. Cross platform sleep - https://stackoverflow.com/a/10928585/5555837
    + Do not allow to open multiple windows of the d-tracker?
        1. Create a file when d-tracker is running
        2. Check if the file exists before starting a new d-tracker instance
        3. If a new d-tracker instance is started and another one is already running exit the new one and put the main one in focus
            1. Comunicate from the second one to the first one (Signals in Unix, shared memory file for windows with a thread for monitoring - https://docs.microsoft.com/en-us/windows/win32/ipc/interprocess-communications)
            2. After receiving the signal make the main window focused (Probably can be done directly using the tekui code from lua).

* Improvements
    + show overview: week, month defaults besides range selector. (improvement over hamster) add possibility to define other default ranges?
        - Can be implemented in a simple way by storing the last search range and by providing two arrows on the side of the date range.
    + Support Latin1 input text in input fields.
