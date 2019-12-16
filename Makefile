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
	cp -R -n dtracker $(DEPLOY_FOLDER)/
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
	install $(DEPLOY_FOLDER)/$(EXECUTABLE) /usr/local/bin/$(EXECUTABLE)
	cp -R -n $(DEPLOY_FOLDER)/dtracker /usr/local/share/lua/5.1/


test: base
	busted spec

clean:
	rm -f -R build
	rm -f *.sqlite3
	rm -f *.xml
	rm -f xml_save_path.lua
