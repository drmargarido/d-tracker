# TODO

* Tasks
    + Add unit tests for the storage
    + Update the dependencies versions

* Bugfix
    + Fix sometimes fields not rerendering when moving and minimizing the window.
    + Fix selection with arrows + shift of text in the input fields(Not consistent in allowing of selection)
    + Input key is consumed after a special char put in the autocomplete fields
    + When shift is pressed in a input with autocomplete while the text is selected in removes the selection making the user not replace the current text.
    + When the popup of the theme changes the alert popup appears in a random place
    + When the main window is closed the other are kept open

* Build releases
    + Macos Binary Release
        - Create an app file
    + PPA for ubuntu auto update.

* Sugestions
    + Minimize to tray
    + Update the timers of the main window every minute? (Does it matter?)

* Improvements
    + Check how to do single row queries with lsqlite and replace the dumb multiple rows instructions in cicles that return only one value.
    + Refactor storage.save implementation to be simpler to understand and read
    + Support Latin1 input text in input fields.
    + Make the task\_reminder plugin also work in windows
      - Make d-tracker be able to be installed in windows
      - Implement desktop notifications (toasts) in windows
    + Allow the copy to clipboard or exporting of the totals in the show overview window
        - C cross-platform simple lib that allows interaction with clipboard - https://github.com/jtanx/libclipboard
