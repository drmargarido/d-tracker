# TODO

* Improve graphical appearance as much as possible
    + Add icon for the window

* Create the popup of task time
    + Edit task start and end dates
    + Edit task name
    + Edit task in progress change
    + Refresh main window after deleting task

* Build the logic for the Main window actions
    + Clear the input fields after adding a task
    + Delete task when pressing del while a task is selected
    + Refresh the whole window after changing data, so it is up to date
    + Bugfix duration of individual tasks not considering the days, months and years
    + Bugfix total duration not considering the days, months and years
    + Bugfix filtering not checking the end_time. If the task start_time to end_time passes the current day it should be shown

* Create window with tasks filtering
    + Display the list of filtered tasks while presenting the days
    + Create the filtering of tasks by day
    + Create the filtering of tasks by week
    + Create the filtering of tasks by date range
    + Search by specific tasks

* Create the display of total times of the filtered tasks
    + Display the total time in each task
    + Display the total time in each project

* Export task to XML
    + Export the tasks filtered by date range to xml
    + Ask for a file path/name when exporting

* Setup unit testing
    + Create test for the task delete
    + Create test for the xml exporting

* Create alternative styles
    + Dark
    + Stain
    + Klinik
    + Monochrome
    + Gradient

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
