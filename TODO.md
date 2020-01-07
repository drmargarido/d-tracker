# TODO

* Bugfix
    + When a task with a big name appears in the show overview window the tasks list will have an horizontal scroll. The trim size of the description/project should be handled according to the window size and never allow the exceeding of the available space. - Check application CanvasHeight and CanvasWidth fields, Widget.askMinMax may also be a good idea.
    + When openning the edit task popup it appears in another window in the corner. It should appear above the current window.
    + Right keyboard numpad number do not work.
    + Fix the description field not updating is color when changing to it using TAB.
    + Fix max trim sizes according to the window width in the whole application.
    + Fix sometimes fields not rerendering when moving and minimizing the window.
    + Borders in the totals of the tasks overview window are visible, they should be white like all the other lists.
    + When pressing the Show Overview in the main window only the current day is shown in the tasks overview, but the last filtered date is kept.
    + Trigger task start when the description field is selected, not autocomplete option is selected and enter is pressed
    + Trigger task start when the project field is selected, not autocomplete option is selected and enter is pressed
    + When the application is opened the autocomplete popup appear out of position
    + Title should show "Description" - "Project"
    + Letter disappearing in the placeholder of the project box
    + Mouse hover in the project changes color? Is it needed?
    + When changing a task time range to a time that overlaps another task it should not be accepted or should try to fix the given range. Possible solution: Reject the modification and report to the user the failure, so he can handle it manually. Tasks in conflict should be presented to the user.
    + Exporting of xml in show overview always puts the file name as a range even when just one day is filtered
    + Crash happened in the first export of the xml?
    + Check if memory is leaking in the show overview queries.
    + When a task is in progress, sometimes the color of the 'Stop Tracking' button turn grey, like if it was disabled.
    + When tabbing from the autocomplete sometimes I got two cursors at the same time

* Validate the success of the database operations in the controllers
    + Task autocomplete
    + Project autocomplete
    + Get task by description

* Implement tests for the new controllers
    + Task autocomplete
    + Project autocomplete
    + Get task by description

* Add error reporting in the new calls to the autocomplete
    + Error reporting in the UI in the case of the description autocomplete fails
    + Error reporting in the UI in the case of the default autocomplete fails

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

* Dependencies support
    + Add compilation instructions for the LuaFileSystem lib for windows
    + Add instructions for compilation of the lsqlite for windows
    + Add instructions for compilation of luajit for windows
    + Add instructions for compilation of the tekui for windows

* Build releases
    + Windows Binary Release
        - Compile the exe file with the wanted icon
    + Macos Binary Release
        - Create an app file
    + AUR package
        - Create a MAKEPKG
        - Register in the AUR platform
    + DEB package?
