LUA_FOLDER=../external/LuaJIT

linux:
	gcc -shared -fPIC `pkg-config --libs --cflags dbus-1` -o lnotify.so \
	  lnotify.c  notify_linux.c -I../external/LuaJIT/src -L../build/ -lluajit
win:
	gcc `pkg-config --libs --cflags dbus-1` notify.c notify_win.c -o notify
clean:
	rm -f lnotify.so
	rm -f notify
example:
	gcc `pkg-config --libs --cflags dbus-1` notify.c notify_linux.c -o notify
