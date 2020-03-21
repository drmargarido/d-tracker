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
    #elif CLI
        /* Load command line arguments to lua global arg table*/
        lua_createtable(L,0,1);
        lua_pushstring(L, "src/cli/main.lua");
        lua_rawseti(L,-2,0);

        for(int i=1;i<argc;i++){
            lua_pushstring(L, argv[i]);
            lua_rawseti(L,-2, i);
        }

        lua_setglobal(L,"arg");

        /* Run cli */
        luaL_loadfile(L, "src/cli/main.lua");
    #else
        luaL_loadfile(L, "src/main.lua");
    #endif

    if (lua_pcall(L, 0, 0, 0) != 0){
        printf("Lua error: %s\n", lua_tostring(L, -1));
    }

    lua_close(L);
    return 0;
}
