#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"
#include "notify.h"

static int f_send_notification(lua_State *L) {
  const char * title = luaL_checkstring(L, 1);
  const char * description = luaL_checkstring(L, 2);
  int result = send_notification(title, description);
  lua_pushnumber(L, result);
  return 1;
}

static const luaL_Reg lib[] = {
  { "send_notification", f_send_notification },
  { NULL,                NULL                }
};

LUALIB_API int luaopen_lnotify(lua_State *L) {
  luaL_openlib(L, "notify", lib, 0);
  return 1;
}

