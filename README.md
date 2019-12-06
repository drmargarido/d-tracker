# Timetracker

Lightweight, cross-platform and simple to setup timetracker. Similar to hamster but uses less than 10MB of RAM, and has 4 small dependencies.

## Milestones

Release 1.0:
* [x] Start task
* [x] Stop task in progress
* [x] Edit the start and end time of an individual task
* [x] Associate a task with a project
* [x] Export filtered tasks to XML with the same format as the hamster timetracker
* [ ] Autocomplete in task creation
* [ ] Listing of tasks per range of days
* [ ] Project/Task Statistics by range of days

Release 1.1:
* [ ] Select themes
* [ ] Command line client


## Build

Build dependencies and the executable for Linux
```sh
make
```

## Testing

To run the tests you will need [busted](http://olivinelabs.com/busted/). With that just run:
```sh
make test
```

## Dependencies

The dependencies are in the external folder.

* luajit - [link](https://luajit.org/)
* lsqlite - [link](http://lua.sqlite.org/index.cgi/index)
* date - [link](https://github.com/Tieske/date)
* tekui - [link](http://tekui.neoscientists.org/)
