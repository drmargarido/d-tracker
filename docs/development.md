# Development

## Guidelines

When developing for D-Tracker the following points must be taken care:
* Compilation must be simple and must keep working in the future
* Dependencies should be managed with care, just use the ones that are really needed
* D-Tracker works at least in Linux and Windows
* The resources usage must be low, right now uses about 10MB or ram and has 0% CPU usage while idle


## Project Structure

```
|src/                - Implementation of the application
|---/ui/             - Application user interface
|---/---/windows/    - Main windows of the interface
|---/---/components/ - UI custom components
|---/controller/     - Logic which present the main system actions and interacts with the database
|---/validators/     - Validators for data
|---/exporter/       - Export tasks lists to files in specific formats
|---/spec/           - Tests to validate the correct behavior of the system
|---/migrations/     - Scripts for to create and update the database model
|---/plugin_manager/ - Implementation of the plugins management and events management
|docs/               - Documentation of the application
|plugins/            - Application plugins
|themes/             - Available CSS themes of the application
|platform/           - Platforms specific settings files, like the mac .app and windows .rc
|external/           - Dependencies repositories
|images/             - Images of the application
|main.c              - Used to create the application embeded with the lua execution
```


## Workflow (Linux)

When developing I compile d-tracker once to generate the build folder. Then since the main application is in lua we do not need to recompile de code(Unless C code is changed).

To edit the application files and have the updated files in the build folder the command `make reload` can be run. In order to not need to call this command at every change when we are developing, usually I just open another terminal and run `while inotifywait -e modify -r ./ ; do make reload; done`.

For this to work you will need the `inotify-tools` package installed.


## Plugins

To implement new plugins check the following instructions.

### Steps to create a new plugin
1. Create a new folder with the plugin name in the `/plugins/` folder.
2. Create the plugin main file inside, something like `/plugins/<plugin_name>/main.lua`.
3. Implement the wanted plugin configuration and event handling.
4. Add the plugin in the list of the plugin lookup file `/plugins/main.lua`.

### Possible Configurations
```lua
conf = {
    in_menu = bool,     -- Will put the plugin in the list of plugins at the main window menubar
    description = text  -- Used as the text to be displayed if appears in the menubar
}
```

### Existing Events
Each plugin can register listeners for each of the following event types:

* INIT - Configuration loaded, migrations setup, before UI starts
* UI_STARTED - Application UI is now up
* CLOSE - Application will close now
* TASK_CREATED - A new task was created
* TASK_STOP - The current task was stopped
* TASK_EDIT - Fields of a task changed
* TASK_DELETE - A task was deleted
* PROJECT_CREATED - A new project was created
* XML_EXPORT - Tasks were exported to a xml file
* PLUGIN_SELECT - The current plugin was selected in the plugins list in the top menubar

### Example
You can check the [theme_switcher](../plugins/theme_switcher/main.lua) plugin as a starting point.


## Themes

To add new themes check the following instructions.

### Steps to create a new theme
1. Make a copy of the `d-tracker.css` theme in the `/themes/` folder and change the name of your theme.
2. Write the rules you want in the css file, be careful the supported rules are not compliant with the latests CSS standards. You can check the other d-tracker themes and also the ones in the `/external/TekUI/tek/ui/style/` folder for extra reference.
3. Copy the `pencil_icon.PPM` icon in the `/images/` folder and put the name you want (Only the ppm format is supported for the icons).
4. Edit the new icon to your taste.
5. Register the theme in the themes lookup file `/src/themes.lua`, the name field is the name of the theme file without the css extension.
