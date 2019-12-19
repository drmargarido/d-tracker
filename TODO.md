# TODO

* Improve graphical appearance as much as possible
    + Fix max trim sizes according to the window width

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
