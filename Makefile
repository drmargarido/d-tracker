DEPLOY_FOLDER=build
EXECUTABLE=d-tracker

LUA_FOLDER=external/LuaJIT
LSQLITE_FOLDER=external/lsqlite
LSQLITE_CFLAGS=-O2

CC=gcc
CFLAGS=-O2


base: structure luajit date tekui lsqlite timetracker

structure:
	mkdir -p $(DEPLOY_FOLDER)
	cp -R -n src $(DEPLOY_FOLDER)/
	cp -R -n images $(DEPLOY_FOLDER)/

luajit:
	cd $(LUA_FOLDER)/ && make
	cp $(LUA_FOLDER)/src/libluajit.so $(DEPLOY_FOLDER)/
	ln -sf $(DEPLOY_FOLDER)/libluajit.so $(DEPLOY_FOLDER)/libluajit-5.1.so.2

tekui:
	cp -R external/tek $(DEPLOY_FOLDER)/
	cp d-tracker.css $(DEPLOY_FOLDER)/tek/ui/style/

lsqlite: sqlite.o
	$(CC) -shared -fPIC $(LSQLITE_CFLAGS) -o $(DEPLOY_FOLDER)/lsqlite3.so $(LSQLITE_FOLDER)/lsqlite3.c $(LSQLITE_FOLDER)/sqlite3.o -I$(LUA_FOLDER)/src -L$(DEPLOY_FOLDER) -lluajit -ldl -lpthread

sqlite.o:
	$(CC) -fPIC $(LSQLITE_CFLAGS) -o $(LSQLITE_FOLDER)/sqlite3.o -c $(LSQLITE_FOLDER)/sqlite3.c

date:
	mkdir -p $(DEPLOY_FOLDER)/date
	cp -R external/date/src/date.lua $(DEPLOY_FOLDER)/date/

timetracker:
	$(CC) $(CFLAGS) -o $(DEPLOY_FOLDER)/$(EXECUTABLE) main.c -I$(LUA_FOLDER)/src -L$(DEPLOY_FOLDER) -lluajit

install:
	# Executable
	cp $(DEPLOY_FOLDER)/$(EXECUTABLE) /usr/bin/$(EXECUTABLE)

	# Main lua code and lua libraries
	mkdir -p /usr/share/lua/5.1/d-tracker
	cp -R $(DEPLOY_FOLDER)/src /usr/share/lua/5.1/d-tracker/
	cp -R $(DEPLOY_FOLDER)/date /usr/share/lua/5.1/d-tracker/

	# Override local lua configuration with the linux one


	# Shared Libraries
	mkdir -p /usr/lib/d-tracker
	cp $(DEPLOY_FOLDER)/libluajit* /usr/lib/d-tracker/
	cp $(DEPLOY_FOLDER)/lsqlite3.so /usr/lib/d-tracker/

	# Desktop configuration and icon
	cp platform/linux/d-tracker.desktop /usr/share/applications/
	cp images/d-tracker.svg /usr/share/icons/hicolor/scalable/apps/

	# Read only data
	mkdir -p /usr/share/d-tracker
	cp -R images /usr/share/d-tracker/images
	cp d-tracker.css /usr/share/d-tracker/

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
