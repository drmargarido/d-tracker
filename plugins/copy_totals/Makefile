LIBCLIPBOARD_FOLDER=external/libclipboard
LUA_FOLDER=../../external/LuaJIT
BUILD_FOLDER=../../build

all:
	gcc $(LIBCLIPBOARD_FOLDER)/src/clipboard_common.c $(LIBCLIPBOARD_FOLDER)/src/clipboard_x11.c \
	-I$(LIBCLIPBOARD_FOLDER)/include -shared -fPIC -O3 -o $(BUILD_FOLDER)/libclipboard.so
	gcc -O3 -shared -fPIC -o $(BUILD_FOLDER)/lclipboard.so lib/lclipboard.c \
	-lclipboard -L$(BUILD_FOLDER) -I$(LIBCLIPBOARD_FOLDER)/include -lX11 -lxcb -pthread \
	-lluajit -I$(LUA_FOLDER)/src/

windows:
	x86_64-w64-mingw32-gcc $(LIBCLIPBOARD_FOLDER)/src/clipboard_common.c $(LIBCLIPBOARD_FOLDER)/src/clipboard_win32.c \
	-I$(LIBCLIPBOARD_FOLDER)/include -shared -fPIC -O3 -o $(BUILD_FOLDER)/libclipboard.dll
	x86_64-w64-mingw32-gcc -O3 -shared -fPIC -o $(BUILD_FOLDER)/lclipboard.dll lib/lclipboard.c \
	-lclipboard -L$(BUILD_FOLDER) -I$(LIBCLIPBOARD_FOLDER)/include -lluajit -I$(LUA_FOLDER)/src/
	

clean:
	rm -f lclipboard.so
	rm -f libclipboard.so
