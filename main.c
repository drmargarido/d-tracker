#include <stdio.h>
#include <stdlib.h>

#include "lua.h"
#include "lualib.h"
#include "lauxlib.h"

#if !defined(CLI)
  #include "lib/clock.h"
#endif

int main(int argc, char ** argv){
  lua_State *L = luaL_newstate();
  luaL_openlibs(L);
  #if !defined(CLI)
    clock_init(L);
  #endif

  #if defined(LINUX_INSTALL) && !defined(CLI)
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

    #ifdef LINUX_INSTALL
      luaL_dostring(L, "package.path = package.path .. ';/usr/share/lua/5.1/d-tracker/?.lua'");
      luaL_dostring(L, "package.cpath = package.cpath .. ';/usr/lib/d-tracker/?.so'");
      luaL_loadfile(L, "/usr/share/lua/5.1/d-tracker/src/cli/main.lua");
    #else
      luaL_loadfile(L, "src/cli/main.lua");
    #endif
  #else
    luaL_loadfile(L, "src/main.lua");
  #endif

  if (lua_pcall(L, 0, 0, 0) != 0){
    printf("Lua error: %s\n", lua_tostring(L, -1));
  }

  #if !defined(CLI)
    clock_close();
  #endif
  lua_close(L);
  return 0;
}
