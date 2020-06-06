
#!/bin/sh

INSTALLDIR=/usr
if [ $# -eq 1 ]; then
    INSTALLDIR=$1
fi

# Executable
mkdir -p ${INSTALLDIR}/bin
cp platform/linux/system_run.sh ${INSTALLDIR}/bin/d-tracker
cp platform/linux/system_cli_run.sh ${INSTALLDIR}/bin/d-tracker-cli
chmod +x ${INSTALLDIR}/bin/d-tracker
chmod +x ${INSTALLDIR}/bin/d-tracker-cli

# Main lua code and lua libraries
mkdir -p ${INSTALLDIR}/share/lua/5.1/d-tracker
cp -R src ${INSTALLDIR}/share/lua/5.1/d-tracker/
cp -R date ${INSTALLDIR}/share/lua/5.1/d-tracker/
cp -R tek ${INSTALLDIR}/share/lua/5.1/d-tracker/
cp -R plugins ${INSTALLDIR}/share/lua/5.1/d-tracker/
cp -R argparse ${INSTALLDIR}/share/lua/5.1/d-tracker/
cp -R VERSION.lua ${INSTALLDIR}/share/lua/5.1/d-tracker/

# Override local lua configuration with the linux one
cp platform/linux/installed_conf.lua ${INSTALLDIR}/share/lua/5.1/d-tracker/src/conf.lua

# Shared Libraries
mkdir -p ${INSTALLDIR}/lib/d-tracker
cp libluajit.so ${INSTALLDIR}/lib/d-tracker/
ln -sf ${INSTALLDIR}/lib/d-tracker/libluajit.so ${INSTALLDIR}/lib/d-tracker/libluajit-5.1.so.2
cp lsqlite3.so ${INSTALLDIR}/lib/d-tracker/
cp lfs.so ${INSTALLDIR}/lib/d-tracker/
cp libfreetype.so ${INSTALLDIR}/lib/d-tracker/
cp lnotify.so ${INSTALLDIR}/lib/d-tracker/
mkdir -p ${INSTALLDIR}/lib/d-tracker/tek
mkdir -p ${INSTALLDIR}/lib/d-tracker/tek/lib
cp -R ${INSTALLDIR}/share/lua/5.1/d-tracker/tek ${INSTALLDIR}/lib/d-tracker/

# Desktop configuration and icons
mkdir -p ${INSTALLDIR}/share/applications
mkdir -p ${INSTALLDIR}/share/pixmaps/
cp platform/linux/d-tracker.desktop ${INSTALLDIR}/share/applications/
cp images/d-tracker_512x512.png ${INSTALLDIR}/share/pixmaps/d-tracker.png

# Read only data
mkdir -p ${INSTALLDIR}/share/d-tracker
mkdir -p ${INSTALLDIR}/share/d-tracker/images
cp -R images/* ${INSTALLDIR}/share/d-tracker/images/
cp platform/linux/d-tracker ${INSTALLDIR}/share/d-tracker/d-tracker
cp platform/linux/d-tracker-cli ${INSTALLDIR}/share/d-tracker/d-tracker-cli
echo "D-Tracker successfully installed!"
exit 0
