# D-Tracker

[![](https://github.com/drmargarido/d-tracker/workflows/Build%20and%20Test/badge.svg)](https://github.com/drmargarido/d-tracker/actions)

Lightweight, cross-platform and simple to setup timetracker. Similar to hamster but uses about 10MB of RAM and has a small quantity of dependencies.


## Motivation

I used hamster timetracker for my projects for years, but lately it disappeared from the debian repositories. I downloaded their latest version from github and it was not working well. After trying their other alternatives it was still not working well, so I decided to build the 'D-Tracker'.

My focus here is to:
* Implement the main features I use regularly.
* Reduce the number of dependencies and build steps so it is easier to make sure the application will still be easy to install in the future.
* Have a small resources usage so I can have it open all day without thinking about it.
* Be cross-platform so it works in more machines(I have never used any of the hamster integrations with the system).

## Milestones

Release 1.0:
* [x] Start task
* [x] Stop task in progress
* [x] Edit the start and end time of an individual task
* [x] Associate a task with a project
* [x] Export filtered tasks to XML with the same format as the hamster timetracker
* [x] Listing of tasks per range of days
* [x] Project/Task Statistics by range of days
* [x] Autocomplete in task creation

Release 1.1:
* [x] Select themes

Release 1.2:
* [x] Command line client

Release 1.3:
* [x] Remember last filtering range in overview window
* [x] Simpler date range navigation in the overview window

Release 1.4:
* [x] Periodically remember the currently active task

Release 1.5:
* [x] Allow the copy of the tasks in the totals window to the clipboard

Release 1.6:
* [ ] Keybindings to speed up the workflow of advanced users

## Screenshots

![D-Tracker UI with Default Theme](/screenshots/d-tracker_v1,1-default.jpg)
![D-Tracker UI with Stain Theme](/screenshots/d-tracker_v1,1-stain.jpg)
![D-Tracker UI with Klinik Theme](/screenshots/d-tracker_v1,1-klinik.jpg)

## Install
To run the application use the most recent release, which right now is the [v1.4](https://github.com/drmargarido/d-tracker/releases).

### Linux

#### Package Manager

* Archlinux AUR - [https://aur.archlinux.org/packages/d-tracker/](https://aur.archlinux.org/packages/d-tracker/)

#### Binary Release

You can download the latest binary [here](https://github.com/drmargarido/d-tracker/releases/tag/v1.4).

The application is self-contained in the folder so if you just want to run it there execute the `run.sh` file.

If you want to install it to the system run the `INSTALL.sh`. When installed in the system and started, a database will be created inside the `~/.local/share/d-tracker/` folder.

To uninstall run the `UNINSTALL.sh` command. It will remove the whole application but still keep the database, so you don't lose your data in case your want to re-install it later.


#### Build from source

The dependencies in the dependencies list are bundled within the repository and will also be compiled. In order to build the project from source you will need the following packages: `automake`, `libtool`, `libx11-dev`, `libxft2-dev`, `libxext-dev`, `libxxf86vm-dev` and `libdbus-1-dev`.

To run the application self contained in a single folder run the following command and check the build/ generated folder.
```sh
make
```

To install the application in the system run:
```sh
make
sudo make install
```

To uninstall the application from the system run:
```sh
sudo make uninstall
```

### Windows

#### Binary Release

You can download the latest binary [here](https://github.com/drmargarido/d-tracker/releases/tag/v1.4).

The application is self-contained in the folder so you just need to run the `d-tracker.exe` file.


#### Build from source

The dependencies in the dependencies list are bundled within the repository and will also be compiled.

My development environment is in Archlinux and Debian so I cross-compile the application. To compile the windows version you will need to have installed the `mingw-w64` package. Then run:
```sh
make release_windows
```

After running the command, the self contained version of the software will be built in the `build/` folder.

## Cli
D-tracker has a cli, `d-tracker-cli` that provides the following commands:

```txt
list-today-tasks      List today tasks
list-tasks            List tasks between a time range
list-projects         Lists the projects available in the database
delete-task           Delete a specific task
add-task              Add a new task
edit-task-time        Edit the time of a specific time
edit-task-description Edit the description of a specific task
edit-task-project     Edit the project of a specific task
export-today-xml      Export today tasks to a xml file
export-xml            Export tasks in a time range to a xml file
stop-in-progress      Stop the current task in progress
```

## Development
If you are interested in improving d-tracker by improving stability, adding new functionalities, plugins, themes or other things check the [development](docs/development.md) section.


## Testing

To run the tests you will need [busted](http://olivinelabs.com/busted/).

**Note**: The tests will create and remove the database inside the build folder, be careful to not run the tests with important data there.

With that just run:
```sh
make test
```

## Dependencies

The dependencies are in the external folder.

* [luajit](https://luajit.org/) - Used as scripting language to implement the application.
* [lsqlite](http://lua.sqlite.org/index.cgi/index) - Contains the database and lua wrapper to communicate with it, so we can store the application data.
* [date](https://github.com/Tieske/date) - Used for parsing and handling of dates.
* [tekui](http://tekui.neoscientists.org/) - Used to implement the whole UI.
* [LuaFileSystem](https://keplerproject.github.io/luafilesystem/manual.html) - Used to list the folders when exporting the tasks to XML.
* [freetype2](https://www.freetype.org/) - (Only for X11) Used in the render of text and fonts in the tekui lib.
* [argparse](https://github.com/luarocks/argparse) - (For the cli) Used to parse the command line options.
* [libclipboard](https://github.com/jtanx/libclipboard) - Used in the copy\_totals plugin to interact with the clipboard.

## Other

A devlog for the development until the version v1.2 is available in [here](https://drmargarido.pt/d_tracker).

