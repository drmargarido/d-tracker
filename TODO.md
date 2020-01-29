# TODO

* Bugfix
    + Fix sometimes fields not rerendering when moving and minimizing the window.
    + Crash happened in the first export of the xml?
    + Check if memory is leaking in the show overview queries. (May be a good idea to manually call collectgarbage to force the cleaning of released data)
    + Autocomplete should also be presented in the edit task window projects field at least.
    + Double refresh call is being done in the stats window when the buttons are pressed

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

* Improvements
    + Refactor the ui windows code in multiple partials in order to be easier to track the dependencies of each part and to be able to make simple unit tests to check at least the base path.
    + minimize to tray
    + show overview: week, month defaults besides range selector. (improvement over hamster) add possibility to define other default ranges?
