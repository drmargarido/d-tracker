# TODO

* Improve graphical appearance as much as possible
    + Add icon for the window
    + Adapt size of trimmed description and project according to the main window size
    + Display task description and project placeholders in input fields
    + Change the task/project input space racio so the description has more space

* Main window fast input
    + Implement autocomplete in the task and project search. This autocomplete should present the last results and filter after starting to write
    + If autocomplete is applied to a task the project should also be automatically filled

* XML export
    + Add default file name according to the date range in the XML export?
    + Store the last save path and use it as the new base path

* Create stats window with tasks filtering
    + Display the list of filtered tasks while presenting the days
    + Create the filtering of tasks by day
    + Create the filtering of tasks by week
    + Create the filtering of tasks by date range
    + Search by specific tasks

* Create the display of total times of the filtered tasks in the stats window
    + Display the total time in each task
    + Display the total time in each project

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
