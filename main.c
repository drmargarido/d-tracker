#include <stdio.h>

#include "lua.h"
#include "lualib.h"
#include "lauxlib.h"

int main(int argc, char ** argv){
    lua_State *L = luaL_newstate();
    luaL_openlibs(L);
    
    luaL_loadfile(L, "src/main.lua");
    if (lua_pcall(L, 0, 0, 0) != 0){            
        printf("Lua error: %s\n", lua_tostring(L, -1));
    }

    lua_close(L);
    return 0;
}