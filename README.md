# Timetracker

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
* [ ] Autocomplete in task creation

Release 1.1:
* [ ] Select themes

Release 1.2:
* [ ] Command line client


## Build

Build dependencies and the executable for Linux
```sh
make
```

## Project Structure

```
|src/               - Implementation of the application
|---/ui/            - Application user interface
|---/controllers/   - Logic which present the main system actions and interacts with the database
|---/validators/    - Validators for data
|---/exporter/      - Exporte tasks lists to files in specific formats
|spec/              - Tests to validate the correct behavior of the system
|platform/          - Platforms specific settings files, like the mac .app and windows .rc
|external/          - Dependencies repositories
|migrations/        - Scripts for to create and update the database model
|main.c             - Used to create the application embeded with the lua execution
```


## Testing

To run the tests you will need [busted](http://olivinelabs.com/busted/). With that just run:
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
