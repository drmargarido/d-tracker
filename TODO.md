# TODO

* Bugfix
    + When a task with a big name appears in the show overview window the tasks list will have an horizontal scroll. The trim size of the description/project should be handled according to the window size and never allow the exceeding of the available space. - Check application CanvasHeight and CanvasWidth fields, Widget.askMinMax may also be a good idea.
    + When openning the edit task popup it appears in another window in the corner. It should appear above the current window.
    + Fix max trim sizes according to the window width in the whole application.
    + Fix sometimes fields not rerendering when moving and minimizing the window.
    + When the application is opened the autocomplete popup appear out of position
    + When changing a task time range to a time that overlaps another task it should not be accepted or should try to fix the given range. Possible solution: Reject the modification and report to the user the failure, so he can handle it manually. Tasks in conflict should be presented to the user.
    + Crash happened in the first export of the xml?
    + Check if memory is leaking in the show overview queries.
    + When closing the d-tracker an error it thrown with the message - "Lua error: ./tek/class/object.lua:126: attempt to get length of local 'n' (a function value)"
    + Its possible to put the end_time of a task before its start time in the edit time window.
    + Totals views should have the time of the projects and tasks sorted by duration
    + Autocomplete should also be presented in the edit task window projects field at least.
    + Show overview filter by name should be kept when the window is closed
    + Make the trim sizes update when the window is resized

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
