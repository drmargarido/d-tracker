DEPLOY_FOLDER=build
EXECUTABLE=d-tracker

LUA_FOLDER=external/LuaJIT
LSQLITE_FOLDER=external/lsqlite
LSQLITE_CFLAGS=-O2

INSTALLDIR?=/usr

UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Linux)
	CC=gcc
endif
ifeq ($(UNAME_S),Darwin)
	CC=clang
endif

CFLAGS=-O2


base: structure linux_platform luajit date argparse freetype2 tekui lsqlite luafilesystem timetracker

# reload used to refresh the build folder while in development
reload: structure
	cp -R themes/* $(DEPLOY_FOLDER)/tek/ui/style/

structure:
	mkdir -p $(DEPLOY_FOLDER)
	cp -R src $(DEPLOY_FOLDER)/
	cp -R images $(DEPLOY_FOLDER)/
	cp -R plugins $(DEPLOY_FOLDER)/

	# Generate a VERSION file using the git tags
	printf "return \"%s\"\n" `git describe --long --tags | sed 's/\([^-]*-g\)/r\1/;s/-/./g;s/^v//'` > $(DEPLOY_FOLDER)/VERSION.lua

linux_platform:
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
	cp themes/* $(DEPLOY_FOLDER)/tek/ui/style/

lsqlite: sqlite.o luajit
	$(CC) -shared -fPIC $(LSQLITE_CFLAGS) -o $(DEPLOY_FOLDER)/lsqlite3.so $(LSQLITE_FOLDER)/lsqlite3.c $(LSQLITE_FOLDER)/sqlite3.o -I$(LUA_FOLDER)/src -L$(DEPLOY_FOLDER) -lluajit -ldl -lpthread

sqlite.o:
	$(CC) -fPIC $(LSQLITE_CFLAGS) -o $(LSQLITE_FOLDER)/sqlite3.o -c $(LSQLITE_FOLDER)/sqlite3.c

date:
	mkdir -p $(DEPLOY_FOLDER)/date
	cp -R external/date/src/date.lua $(DEPLOY_FOLDER)/date/

argparse:
	mkdir -p $(DEPLOY_FOLDER)/argparse
	cp -R external/argparse/src/argparse.lua $(DEPLOY_FOLDER)/argparse/

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

	$(CC) $(CFLAGS) -o $(DEPLOY_FOLDER)/$(EXECUTABLE)-cli main.c -I$(LUA_FOLDER)/src -L$(DEPLOY_FOLDER) -lluajit -DCLI

	# Compile executable version with global system paths instead of the local ones
	$(CC) $(CFLAGS) -o $(DEPLOY_FOLDER)/platform/linux/$(EXECUTABLE) main.c -I$(LUA_FOLDER)/src -L$(DEPLOY_FOLDER) -lluajit -DLINUX_INSTALL

	# Put INSTALL and UNINSTALL scripts in the base path
	cp $(DEPLOY_FOLDER)/platform/linux/INSTALL.sh $(DEPLOY_FOLDER)/
	chmod +x $(DEPLOY_FOLDER)/INSTALL.sh

	cp $(DEPLOY_FOLDER)/platform/linux/UNINSTALL.sh $(DEPLOY_FOLDER)/
	chmod +x $(DEPLOY_FOLDER)/UNINSTALL.sh

install:
	cd $(DEPLOY_FOLDER) && sh INSTALL.sh ${INSTALLDIR}

uninstall:
	cd $(DEPLOY_FOLDER) && sh UNINSTALL.sh

test:
	# To run the test some deploy should already have been done
	cd $(DEPLOY_FOLDER) && busted src/spec

clean:
	rm -f -R build
	rm -f *.sqlite3
	rm -f *.xml
	rm -f xml_save_path.lua
	rm -f *.res

	cd external/freetype2/ && make clean
	cd external/LuaJIT/ && make clean
	cd external/luafilesystem/ && make clean
	cd external/tekUI/ && make clean

release_windows: structure date
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
	cp themes/* $(DEPLOY_FOLDER)/tek/ui/style/

	# luafilesystem
	cd external/luafilesystem && make -f Makefile.crosswin
	cp external/luafilesystem/src/lfs.dll $(DEPLOY_FOLDER)/

	# D-tracker with icon
	x86_64-w64-mingw32-windres platform/windows/resources.rc -O coff -o resources.res
	x86_64-w64-mingw32-gcc -O3 -o $(DEPLOY_FOLDER)/$(EXECUTABLE).exe main.c -I$(LUA_FOLDER)/src -L$(DEPLOY_FOLDER) -llua51 resources.res

release_mac: structure date freetype2 tekui lsqlite luafilesystem timetracker
	# Luajit
	cd $(LUA_FOLDER)/ && MACOSX_DEPLOYMENT_TARGET=10.12 make TARGET_SYS=Darwin
	cp $(LUA_FOLDER)/src/libluajit.so $(DEPLOY_FOLDER)/
	cd $(DEPLOY_FOLDER) && ln -sf libluajit.so libluajit-5.1.so.2

	# Create app file
	mkdir -p d-tracker.app
	mkdir -p d-tracker.app/Contents
	cp platform/mac/Info.plist d-tracker.app/Contents/

	mkdir -p d-tracker.app/Contents/Resources
	cp images/d-tracker.icns d-tracker.app/Contents/Resources

	mkdir -p d-tracker.app/Contents/MacOS
	cp -R $(DEPLOY_FOLDER)/* d-tracker.app/Contents/MacOS/

	rm -R $(DEPLOY_FOLDER)/*
	mv d-tracker.app $(DEPLOY_FOLDER)/d-tracker.app

