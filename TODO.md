# TODO

* Bugfix
    + When openning the edit task popup it appears in another window in the corner. It should appear above the current window.
    + Fix sometimes fields not rerendering when moving and minimizing the window.
    + When the application is opened the autocomplete popup appear out of position
    + When changing a task time range to a time that overlaps another task it should not be accepted or should try to fix the given range. Possible solution: Reject the modification and report to the user the failure, so he can handle it manually. Tasks in conflict should be presented to the user.
    + Crash happened in the first export of the xml?
    + Check if memory is leaking in the show overview queries.
    + When closing the d-tracker an error it thrown with the message - "Lua error: ./tek/class/object.lua:126: attempt to get length of local 'n' (a function value)"
    + Its possible to put the end_time of a task before its start time in the edit time window.
    + Autocomplete should also be presented in the edit task window projects field at least.
    + Double refresh call is being done in the stats window when the buttons are pressed

* Windows specific bugs
    + Colors and text fonts are a bit messed (Do something or wait for the themes?)

* Create alternative styles
    + Dark
    + Stain
    + Klinik
    + Monochrome
    + Gradient

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
    + AUR package
        - Create a MAKEPKG
        - Register in the AUR platform
    + DEB package?
