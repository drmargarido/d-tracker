# TODO

* Tasks
    + Add unit tests for the storage
    + Update the dependencies versions

* Bugfix
    + Fix sometimes fields not re-rendering when moving and minimizing the window.
    + Fix selection with arrows + shift of text in the input fields(Not consistent in allowing of selection)
    + Input key is consumed after a special char put in the autocomplete fields
    + When shift is pressed in a input with autocomplete while the text is selected in removes the selection making the user not replace the current text.
    + When the popup of the theme changes the alert popup appears in a random place
    + When the main window is closed the other are kept open
    + When d-tracker is minimized if a popup window is open it will be kept in focus
    + The about window should display the links in a text field so the user can copy them
    + Exporting the xml in the show overview window fails to use the already known export path
    + The projects field in the task edit accepts empty input creating an empty project
    + Fix re-rendering damaged areas under wayland, it fails too much

* Build releases
    + PPA for ubuntu auto update.
    + Add automatic build and release after a pull request is merged into master
      + Release description https://github.com/marketplace/actions/release-drafter
      + Upload assets https://github.com/marketplace/actions/upload-a-release-asset
      + Create release https://github.com/marketplace/actions/create-a-release
      + Example of build and deploy - https://github.com/andsve/lite-macos/blob/feature/macos-rendering/.github/workflows/main.yml

* Sugestions
    + Minimize to tray
    + Update the timers of the main window every minute? (Does it matter?)

* Improvements
    + Check how to do single row queries with lsqlite and replace the dumb multiple rows instructions in cycles that return only one value.
    + Refactor storage.save implementation to be simpler to understand and read
    + Support Latin1 input text in input fields.
    + Make the task\_reminder plugin also work in windows
      - Note, notifications on windows only work for installed apps.
      - Make d-tracker be able to be installed in windows
      - Implement desktop notifications (toasts) in windows
    + Allow the copy to clipboard or exporting of the totals in the show overview window
        - C cross-platform simple lib that allows interaction with clipboard - https://github.com/jtanx/libclipboard
