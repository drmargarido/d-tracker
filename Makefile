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
	cp external/tekUI/config_linux external/tekUI/config
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

	# Put INSTALL and UNINSTALL scripts in the base path
	cp $(DEPLOY_FOLDER)/platform/linux/INSTALL.sh $(DEPLOY_FOLDER)/
	chmod +x $(DEPLOY_FOLDER)/INSTALL.sh

	cp $(DEPLOY_FOLDER)/platform/linux/UNINSTALL.sh $(DEPLOY_FOLDER)/
	chmod +x $(DEPLOY_FOLDER)/UNINSTALL.sh

install:
	cd $(DEPLOY_FOLDER) && sh INSTALL.sh

uninstall:
	cd $(DEPLOY_FOLDER) && sh UNINSTALL.sh

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

release_windows:
	# Structure
	mkdir -p $(DEPLOY_FOLDER)
	cp -R src $(DEPLOY_FOLDER)/
	cp -R images $(DEPLOY_FOLDER)/
	mkdir -p $(DEPLOY_FOLDER)/platform

	# Luajit
	cd external/LuaJIT/src && make HOST_CC="gcc" CROSS=x86_64-w64-mingw32- TARGET_SYS=Windows
	cp $(LUA_FOLDER)/src/lua51.dll $(DEPLOY_FOLDER)/

	# lsqlite
	x86_64-w64-mingw32-gcc -fPIC $(LSQLITE_CFLAGS) -o $(LSQLITE_FOLDER)/sqlite3.o -c $(LSQLITE_FOLDER)/sqlite3.c
	x86_64-w64-mingw32-gcc -shared -fPIC $(LSQLITE_CFLAGS) -o $(DEPLOY_FOLDER)/lsqlite3.dll $(LSQLITE_FOLDER)/lsqlite3.c $(LSQLITE_FOLDER)/sqlite3.o -I$(LUA_FOLDER)/src -L$(DEPLOY_FOLDER) -llua51

	# Tekui
	cp external/tekUI/config_windows external/tekUI/config
	cd external/tekUI && make all
	cp -R external/tekUI/tek $(DEPLOY_FOLDER)/
	cp d-tracker.css $(DEPLOY_FOLDER)/tek/ui/style/

	# date
	mkdir -p $(DEPLOY_FOLDER)/date
	cp -R external/date/src/date.lua $(DEPLOY_FOLDER)/date/

	# luafilesystem
	cd external/luafilesystem && make -f Makefile.crosswin
	cp external/luafilesystem/src/lfs.dll $(DEPLOY_FOLDER)/

	# D-tracker
	x86_64-w64-mingw32-gcc -O3 -o $(DEPLOY_FOLDER)/$(EXECUTABLE).exe main.c -I$(LUA_FOLDER)/src -L$(DEPLOY_FOLDER) -llua51
