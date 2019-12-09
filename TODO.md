# TODO

* General
    + Add error handling if the database queries fail
    + Add error handling when creating the xml exported file
    + Add error handling when creating the database the first time
    + Add standardized error reporting in the UI
    + Add standardized error returning from controllers
    + Add parameters type validations in the controllers
    + Test for sql injections

* Improve graphical appearance as much as possible
    + Add icon for the window
    + Adapt size of trimmed description and project according to the main window size
    + Display task description and project placeholders in input fields

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
