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

* Main window fast input
    + Implement autocomplete in the task and project search. This autocomplete should present the last results and filter after starting to write
    + If autocomplete is applied to a task the project should also be automatically filled

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
