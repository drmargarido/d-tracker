DEPLOY_FOLDER=build
EXECUTABLE=d-tracker

LUA_FOLDER=external/LuaJIT
LSQLITE_FOLDER=external/lsqlite
LSQLITE_CFLAGS=-O2

CC=gcc
CFLAGS=-O2


base: structure luajit date freetype2 tekui lsqlite luafilesystem timetracker

structure:
	mkdir -p $(DEPLOY_FOLDER)
	cp -R src $(DEPLOY_FOLDER)/
	cp -R images $(DEPLOY_FOLDER)/
	mkdir -p $(DEPLOY_FOLDER)/platform
	cp -R platform/linux $(DEPLOY_FOLDER)/platform/

luajit:
	cd $(LUA_FOLDER)/ && make
	cp $(LUA_FOLDER)/src/libluajit.so $(DEPLOY_FOLDER)/
	cd $(DEPLOY_FOLDER) && ln -sf libluajit.so libluajit-5.1.so.2

tekui: freetype2 luajit
	cd external/tekUI && make all
	cp -R external/tekUI/tek $(DEPLOY_FOLDER)/
	cp d-tracker.css $(DEPLOY_FOLDER)/tek/ui/style/

lsqlite: sqlite.o luajit
	$(CC) -shared -fPIC $(LSQLITE_CFLAGS) -o $(DEPLOY_FOLDER)/lsqlite3.so $(LSQLITE_FOLDER)/lsqlite3.c $(LSQLITE_FOLDER)/sqlite3.o -I$(LUA_FOLDER)/src -L$(DEPLOY_FOLDER) -lluajit -ldl -lpthread

sqlite.o:
	$(CC) -fPIC $(LSQLITE_CFLAGS) -o $(LSQLITE_FOLDER)/sqlite3.o -c $(LSQLITE_FOLDER)/sqlite3.c

date:
	mkdir -p $(DEPLOY_FOLDER)/date
	cp -R external/date/src/date.lua $(DEPLOY_FOLDER)/date/

luafilesystem: luajit
	cd external/luafilesystem && make
	cp external/luafilesystem/src/lfs.so $(DEPLOY_FOLDER)/

freetype2:
	cd external/freetype2 && ./autogen.sh
	cd external/freetype2 && ./configure
	cd external/freetype2 && make
	cp external/freetype2/objs/.libs/libfreetype.so $(DEPLOY_FOLDER)/

timetracker: luajit
	$(CC) $(CFLAGS) -o $(DEPLOY_FOLDER)/$(EXECUTABLE) main.c -I$(LUA_FOLDER)/src -L$(DEPLOY_FOLDER) -lluajit
	cp $(DEPLOY_FOLDER)/platform/linux/local_run.sh $(DEPLOY_FOLDER)/run.sh
	chmod +x $(DEPLOY_FOLDER)/run.sh

	# Compile executable version with global system paths instead of the local ones
	$(CC) $(CFLAGS) -o $(DEPLOY_FOLDER)/platform/linux/$(EXECUTABLE) main.c -I$(LUA_FOLDER)/src -L$(DEPLOY_FOLDER) -lluajit -DLINUX_INSTALL

install:
	# Executable
	cp $(DEPLOY_FOLDER)/platform/linux/$(EXECUTABLE) /usr/bin/$(EXECUTABLE)

	# Main lua code and lua libraries
	mkdir -p /usr/share/lua/5.1/d-tracker
	cp -R $(DEPLOY_FOLDER)/src /usr/share/lua/5.1/d-tracker/
	cp -R $(DEPLOY_FOLDER)/date /usr/share/lua/5.1/d-tracker/
	cp -R $(DEPLOY_FOLDER)/tek /usr/share/lua/5.1/d-tracker/

	# Override local lua configuration with the linux one
	cp $(DEPLOY_FOLDER)/platform/linux/installed_conf.lua /usr/share/lua/5.1/d-tracker/src/conf.lua

	# Shared Libraries
	mkdir -p /usr/lib/d-tracker
	cp $(DEPLOY_FOLDER)/libluajit.so /usr/lib/d-tracker/
	ln -sf /usr/lib/d-tracker/libluajit.so /usr/lib/d-tracker/libluajit-5.1.so.2
	cp $(DEPLOY_FOLDER)/lsqlite3.so /usr/lib/d-tracker/
	cp $(DEPLOY_FOLDER)/lfs.so /usr/lib/d-tracker/
	cp $(DEPLOY_FOLDER)/libfreetype.so /usr/lib/d-tracker/
	mkdir -p /usr/lib/d-tracker/tek
	mkdir -p /usr/lib/d-tracker/tek/lib
	cp -R /usr/share/lua/5.1/d-tracker/tek /usr/lib/d-tracker/

	# Desktop configuration and icons
	cp $(DEPLOY_FOLDER)/platform/linux/d-tracker.desktop /usr/share/applications/
	cp $(DEPLOY_FOLDER)/images/d-tracker_512x512.png /usr/share/pixmaps/d-tracker.png

	# Read only data
	mkdir -p /usr/share/d-tracker
	cp -R $(DEPLOY_FOLDER)/images /usr/share/d-tracker/images

	echo "D-Tracker successfully installed!"

uninstall:
	rm -f /usr/bin/$(EXECUTABLE)
	rm -R -f /usr/share/lua/5.1/d-tracker
	rm -f /usr/share/applications/d-tracker.desktop
	rm -f /usr/share/pixmaps/d-tracker.png

	rm -R -f /usr/share/d-tracker
	rm -R -f /usr/lib/d-tracker

	echo "D-Tracker uninstalled from the system!"

test: base
	cd $(DEPLOY_FOLDER) && busted src/spec

clean:
	rm -f -R build
	rm -f *.sqlite3
	rm -f *.xml
	rm -f xml_save_path.lua

	cd external/freetype2/ && make clean
	cd external/LuaJIT/ && make clean
	cd external/luafilesystem/ && make clean
	cd external/tekUI/ && make clean
