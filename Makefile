DEPLOY_FOLDER=build
EXECUTABLE=d-tracker

LUA_FOLDER=external/LuaJIT
LSQLITE_FOLDER=external/lsqlite
LSQLITE_CFLAGS=-O2

CC=gcc
CFLAGS=-O2


base: structure luajit date tekui lsqlite luafilesystem timetracker

structure:
	mkdir -p $(DEPLOY_FOLDER)
	cp -R -n src $(DEPLOY_FOLDER)/
	cp -R -n images $(DEPLOY_FOLDER)/

luajit:
	cd $(LUA_FOLDER)/ && make
	cp $(LUA_FOLDER)/src/libluajit.so $(DEPLOY_FOLDER)/
	ln -sf $(DEPLOY_FOLDER)/libluajit.so $(DEPLOY_FOLDER)/libluajit-5.1.so.2

tekui:
	cd external/tekUI && make all
	cp -R external/tekUI/tek $(DEPLOY_FOLDER)/
	cp d-tracker.css $(DEPLOY_FOLDER)/tek/ui/style/

lsqlite: sqlite.o
	$(CC) -shared -fPIC $(LSQLITE_CFLAGS) -o $(DEPLOY_FOLDER)/lsqlite3.so $(LSQLITE_FOLDER)/lsqlite3.c $(LSQLITE_FOLDER)/sqlite3.o -I$(LUA_FOLDER)/src -L$(DEPLOY_FOLDER) -lluajit -ldl -lpthread

sqlite.o:
	$(CC) -fPIC $(LSQLITE_CFLAGS) -o $(LSQLITE_FOLDER)/sqlite3.o -c $(LSQLITE_FOLDER)/sqlite3.c

date:
	mkdir -p $(DEPLOY_FOLDER)/date
	cp -R external/date/src/date.lua $(DEPLOY_FOLDER)/date/

luafilesystem: luajit
	cd external/luafilesystem && make
	cp external/luafilesystem/src/lfs.so $(DEPLOY_FOLDER)/

timetracker:
	$(CC) $(CFLAGS) -o $(DEPLOY_FOLDER)/$(EXECUTABLE) main.c -I$(LUA_FOLDER)/src -L$(DEPLOY_FOLDER) -lluajit

install:
	# Executable
	cp $(DEPLOY_FOLDER)/$(EXECUTABLE) /usr/bin/$(EXECUTABLE)

	# Main lua code and lua libraries
	mkdir -p /usr/share/lua/5.1/d-tracker
	cp -R $(DEPLOY_FOLDER)/src /usr/share/lua/5.1/d-tracker/
	cp -R $(DEPLOY_FOLDER)/date /usr/share/lua/5.1/d-tracker/
	cp -R $(DEPLOY_FOLDER)/tek /usr/share/lua/5.1/d-tracker/

	# Override local lua configuration with the linux one


	# Shared Libraries
	mkdir -p /usr/lib/d-tracker
	cp $(DEPLOY_FOLDER)/libluajit* /usr/lib/d-tracker/
	cp $(DEPLOY_FOLDER)/lsqlite3.so /usr/lib/d-tracker/
	cp $(DEPLOY_FOLDER)/lfs.so /usr/lib/d-tracker/

	# Desktop configuration and icon
	cp platform/linux/d-tracker.desktop /usr/share/applications/
	cp images/d-tracker.svg /usr/share/icons/hicolor/scalable/apps/d-tracker.svg
	cp images/d-tracker_32x32.png /usr/share/icons/hicolor/32x32/apps/d-tracker.png
	cp images/d-tracker_64x64.png /usr/share/icons/hicolor/64x64/apps/d-tracker.png
	cp images/d-tracker_128x128.png /usr/share/icons/hicolor/128x128/apps/d-tracker.png
	cp images/d-tracker_256x256.png /usr/share/icons/hicolor/256x256/apps/d-tracker.png
	cp images/d-tracker_512x512.png /usr/share/icons/hicolor/512x512/apps/d-tracker.png

	# Read only data
	mkdir -p /usr/share/d-tracker
	cp -R images /usr/share/d-tracker/images

	echo "D-Tracker successfully installed!"

uninstall:
	rm -R /usr/bin/$(EXECUTABLE)
	rm -R /usr/share/lua/5.1/d-tracker
	rm -R /usr/share/applications/d-tracker.desktop
	rm -R /usr/share/icons/hicolor/scalable/apps/d-tracker.svg
	rm -R /usr/share/d-tracker
	rm -R /usr/lib/d-tracker

	echo "D-Tracker uninstalled from the system!"

test: base
	cd $(DEPLOY_FOLDER) && busted src/spec

clean:
	rm -f -R build
	rm -f *.sqlite3
	rm -f *.xml
	rm -f xml_save_path.lua
