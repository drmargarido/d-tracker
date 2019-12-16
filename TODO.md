# TODO

* Maintainabilty
    + Create migrations table in the database
    + Make the initial database creation also check for missing migrations so if a new version of the program is released the users can have their database updated

* Improve graphical appearance as much as possible
    + Add icon for the window

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
    + Add LuaFileSystem lib to the dependencies list
    + Add compilation instructions for the LuaFileSystem lib for linux/POSIX
    + Add compilation instructions for the LuaFileSystem lib for windows
    + Add the source of the tekui project instead of the ready dependencies
    + Add instructions for compilation of the lsqlite for windows
    + Add instructions for compilation of luajit for windows
    + Add instructions for compilation of the tekui for linux/POSIX
    + Add instructions for compilation of the tekui for windows

* Linux Build
    + Executable in /usr/bin/d-tracker
    + Bundle lua files and put them in the /usr/share/lua/5.1/dtracker
    + Put dependencies shared objects in /usr/lib/d-tracker
    + Put the images and read only application content in /usr/share/d-tracker
    + Put the runtime data(DB and XML path) in  ~/.local/share/d-tracker/
    + Put the d-tracker icon in the hicolor theme in /usr/share/icons/*/apps/d-tracker.(svg|png)
    + Make main.c lua path configurable

* Build releases
    + Windows Binary Release
        - Compile the exe file with the wanted icon
    + Macos Binary Release
        - Create an app file
    + Linux Binary Release
    + Linux Source Release
        - .desktop file to install the application
        - Setup the `make install` command
    + AUR package
        - Create a MAKEPKG
        - Register in the AUR platform
    + DEB package?
