#include <stdio.h>
#include <stdlib.h>

#include "lua.h"
#include "lualib.h"
#include "lauxlib.h"

int main(int argc, char ** argv){
    lua_State *L = luaL_newstate();
    luaL_openlibs(L);

    #ifdef LINUX_INSTALL
        luaL_dostring(L, "package.path = package.path .. ';/usr/share/lua/5.1/d-tracker/?.lua'");
        luaL_dostring(L, "package.cpath = package.cpath .. ';/usr/lib/d-tracker/?.so'");
        luaL_loadfile(L, "/usr/share/lua/5.1/d-tracker/src/main.lua");
    #else
        char * library_path = getenv("LD_LIBRARY_PATH");
        char * current_dir = getenv("PWD");

        char new_library_path[4096] = "";
        snprintf(new_library_path, 4096, "%s:%s", library_path, current_dir);
        setenv ("LD_LIBRARY_PATH", new_library_path, 1);

        luaL_dostring(L, "package.cpath = package.cpath .. ';?.so'");
        luaL_loadfile(L, "src/main.lua");
    #endif
    if (lua_pcall(L, 0, 0, 0) != 0){
        printf("Lua error: %s\n", lua_tostring(L, -1));
    }

    lua_close(L);
    return 0;
}
