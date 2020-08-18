LIBCLIPBOARD_FOLDER=external/libclipboard
LUA_FOLDER=../../external/LuaJIT
BUILD_FOLDER=../../build

all:
	cd $(LIBCLIPBOARD_FOLDER) && cmake -DBUILD_SHARED_LIBS=ON && make
	cp $(LIBCLIPBOARD_FOLDER)/lib/libclipboard.so $(BUILD_FOLDER)
	gcc -O3 -shared -fPIC -o $(BUILD_FOLDER)/lclipboard.so lib/lclipboard.c \
	-lclipboard -L$(BUILD_FOLDER) -I$(LIBCLIPBOARD_FOLDER)/include -lX11 -lxcb -pthread \
	-lluajit -I$(LUA_FOLDER)/src/
		
clean:
	rm -f lclipboard.so
	rm -f libclipboard.so