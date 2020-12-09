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
    + The about window should allow the copy of links
    + Fix re-rendering damaged areas under wayland, it fails too much
    + Copying stuff on one d-tracker window and then trying to paste it in another d-tracker window crashes d-tracker

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
    + Clipboard fails in some cases.
      - Try the tekui internal clipboard
    + Make the task\_reminder plugin also work in windows
      - Note, notifications on windows only work for installed apps.
      - Make d-tracker be able to be installed in windows
      - Implement desktop notifications (toasts) in windows


