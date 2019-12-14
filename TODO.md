# TODO

* Maintainabilty
    + Create migrations table in the database
    + Make the initial database creation also check for missing migrations so if a new version of the program is released the users can have their database updated

* Improve graphical appearance as much as possible
    + Add icon for the window

* Main window fast input
    + Implement autocomplete in the task and project search. This autocomplete should present the last results and filter after starting to write
    + If autocomplete is applied to a task the project should also be automatically filled

* Create stats window with tasks filtering
    + Search by specific tasks
    + Allow delete of tasks and update the window
    + Implement the XML export

* Create alternative styles
    + Dark
    + Stain
    + Klinik
    + Monochrome
    + Gradient

* Dependencies support
    + Add LuaFileSystem lib to the dependencies list
    + Add compilation instructions for the LuaFileSystem lib for linux/POSIX
    + Add compilation instructions for the LuaFileSystem lib for windows
    + Add the source of the tekui project instead of the ready dependencies
    + Add instructions for compilation of the lsqlite for windows
    + Add instructions for compilation of luajit for windows
    + Add instructions for compilation of the tekui for linux/POSIX
    + Add instructions for compilation of the tekui for windows

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
