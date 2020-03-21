#!/bin/sh

rm -f /usr/bin/d-tracker
rm -f /usr/bin/d-tracker-cli
rm -R -f /usr/share/lua/5.1/d-tracker
rm -f /usr/share/applications/d-tracker.desktop
rm -f /usr/share/pixmaps/d-tracker.png

rm -R -f /usr/share/d-tracker
rm -R -f /usr/lib/d-tracker

echo "D-Tracker uninstalled from the system!"
