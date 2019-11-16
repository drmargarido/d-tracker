# Timetracker

Lightweight, cross-platform and simple to setup timetracker. Similar to hamster but uses less than 10MB of RAM and has 4 small dependencies instead of asking you to use DOCKER.

## Milestones

Release 1.0:
* [ ] Start task
* [ ] Stop task in progress
* [ ] Edit the start and end time of an individual task
* [ ] Autocomplete in task creation
* [ ] Associate a task with a project
* [ ] Listing of tasks per range of days
* [ ] Export filtered tasks to XML with the same format as the hamster timetracker

## Build

Build dependencies and the executable for Linux
```sh
make
```

## Dependencies

* luajit - [link](https://luajit.org/)
* lsqlite - [link](http://lua.sqlite.org/index.cgi/index)
* date - [link](https://github.com/Tieske/date)
* tekui - [link](http://tekui.neoscientists.org/)
