LIBCLIPBOARD_FOLDER=external/libclipboard
LUA_FOLDER=../../external/LuaJIT
BUILD_FOLDER=../../build

linux: prepare
	gcc $(LIBCLIPBOARD_FOLDER)/src/clipboard_common.c $(LIBCLIPBOARD_FOLDER)/src/clipboard_x11.c \
	-I$(LIBCLIPBOARD_FOLDER)/include -shared -fPIC -O3 -o $(BUILD_FOLDER)/libclipboard.so
	gcc -O3 -shared -fPIC -o $(BUILD_FOLDER)/lclipboard.so lib/lclipboard.c \
	-lclipboard -L$(BUILD_FOLDER) -I$(LIBCLIPBOARD_FOLDER)/include -lX11 -lxcb -pthread \
	-lluajit -I$(LUA_FOLDER)/src/

release_windows: prepare
	x86_64-w64-mingw32-gcc $(LIBCLIPBOARD_FOLDER)/src/clipboard_win32.c \
	$(LIBCLIPBOARD_FOLDER)/src/clipboard_common.c -I$(LIBCLIPBOARD_FOLDER)/include/ -D_WIN32 \
	-DLIBCLIPBOARD_BUILD_SHARED -DLIBCLIPBOARD_BUILD_WIN32 -Dclipboard_EXPORTS \
	-shared -fPIC -O3 -o $(BUILD_FOLDER)/libclipboard.dll
	x86_64-w64-mingw32-gcc lib/lclipboard.c -shared -fPIC -O3 -I$(LUA_FOLDER)/src/ \
	-I$(LIBCLIPBOARD_FOLDER)/include/ -L$(BUILD_FOLDER) -llua51 -lclipboard \
	-o $(BUILD_FOLDER)/lclipboard.dll

prepare:
	cd $(LIBCLIPBOARD_FOLDER) && cmake .

clean:
	rm -f lclipboard.so
	rm -f libclipboard.so
