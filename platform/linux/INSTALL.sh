#!/bin/sh

# Executable
cp platform/linux/system_run.sh /usr/bin/d-tracker
chmod +x /usr/bin/d-tracker

# Main lua code and lua libraries
mkdir -p /usr/share/lua/5.1/d-tracker
cp -R src /usr/share/lua/5.1/d-tracker/
cp -R date /usr/share/lua/5.1/d-tracker/
cp -R tek /usr/share/lua/5.1/d-tracker/

# Override local lua configuration with the linux one
cp platform/linux/installed_conf.lua /usr/share/lua/5.1/d-tracker/src/conf.lua

# Shared Libraries
mkdir -p /usr/lib/d-tracker
cp libluajit.so /usr/lib/d-tracker/
ln -sf /usr/lib/d-tracker/libluajit.so /usr/lib/d-tracker/libluajit-5.1.so.2
cp lsqlite3.so /usr/lib/d-tracker/
cp lfs.so /usr/lib/d-tracker/
cp libfreetype.so /usr/lib/d-tracker/
mkdir -p /usr/lib/d-tracker/tek
mkdir -p /usr/lib/d-tracker/tek/lib
cp -R /usr/share/lua/5.1/d-tracker/tek /usr/lib/d-tracker/

# Desktop configuration and icons
cp platform/linux/d-tracker.desktop /usr/share/applications/
cp images/d-tracker_512x512.png /usr/share/pixmaps/d-tracker.png

# Read only data
mkdir -p /usr/share/d-tracker
cp -R images /usr/share/d-tracker/images
cp platform/linux/d-tracker /usr/share/d-tracker/d-tracker

echo "D-Tracker successfully installed!"
exit 0
