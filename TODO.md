# TODO

* Bugfix
    + Fix sometimes fields not rerendering when moving and minimizing the window.
    + Crash happened in the first export of the xml?
    + Fix selection with arrows + shift of text in the input fields(Not consistent in allowing of selection)
    + Input key is consumed after a special char put in the autocomplete fields
    + When shift is pressed in a input with autocomplete while the text is selected in removes the selection making the user not replace the current text.

* Implement a command line interface to interact with D-tracker
    + Command line arguments parsing in pure lua -> https://github.com/ncopa/lua-optarg | https://github.com/luarocks/argparse
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
    + DEB package?

* Sugestions
    + Minimize to tray
    + Update the timers of the main window every minute? (Does it matter?)
        1. Coroutine in lua running time counting and triggering the update every minute or thread in C running a refresh method received from lua
        2. Cross platform sleep - https://stackoverflow.com/a/10928585/5555837

* Improvements
    + show overview: week, month defaults besides range selector. (improvement over hamster) add possibility to define other default ranges?
        - Can be implemented in a simple way by storing the last search range and by providing two arrows on the side of the date range.
    + Support Latin1 input text in input fields.
    + Add plugin which allow the scheduling of desktop notifications saying the current active task every group of minutes.
        - Example -> https://github.com/gaborcsardi/notifier
        - Example -> https://www.devdungeon.com/content/windows-desktop-notifications-python
        - Example Go cross-platform notifications -> https://github.com/gen2brain/beeep
        - List of linux notification tools -> https://wiki.archlinux.org/index.php/Desktop_notifications#C
        - Gnome Notification spec -> https://people.gnome.org/~mccann/docs/notification-spec/notification-spec-latest.html
        - Using DBus in C (Can be used to connect to the gnome notifications) -> https://linoxide.com/how-tos/d-bus-ipc-mechanism-linux/
        - Windows-10-Toast-Notifications -> https://github.com/jithurjacob/Windows-10-Toast-Notifications
        - Notification daemons for i3 -> https://faq.i3wm.org/question/121/whats-a-good-notification-daemon-for-i3.1.html
        - Notification Spec (used by notify-send) -> http://www.galago-project.org/specs/notification/0.9/x81.html
        - Macos notification rust lib -> https://github.com/h4llow3En/mac-notification-sys
        - Lib with swift and actionscript works on mac and windows -> https://github.com/tuarua/DesktopToastANE
