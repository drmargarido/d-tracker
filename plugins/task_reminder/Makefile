LUA_FOLDER=../../external/LuaJIT
BUILD_FOLDER=../../build

linux:
	gcc -shared -fPIC -O3 -o lnotify.so lib/lnotify.c  lib/notify_linux.c \
	 -I$(LUA_FOLDER)/src -L$(BUILD_FOLDER)/ -lluajit \
	 `pkg-config --libs --cflags dbus-1`
clean:
	rm -f lnotify.so
