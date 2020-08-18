#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"
#include "libclipboard.h"

static clipboard_c *cb;

// Lua bindings to Interact with the clipboard
static int f_init(lua_State *L){
  cb = clipboard_new(NULL);
  int result = 1;
  if (cb == NULL) {
    printf("Clipboard initialization failed!\n");
    result = 0;
  }
  lua_pushnumber(L, result);
  return 1;
}

static int f_close(lua_State *L){
  clipboard_free(cb);
  return 0;
}

static int f_get_text(lua_State *L) {
  const char * text = clipboard_text(cb);
  lua_pushstring(L, text);
  return 1;
}

static int f_set_text(lua_State *L) {
  int result = 0;
  if(cb != NULL){
    const char * text = luaL_checkstring(L, 1);
    result = clipboard_set_text(cb, text);
  }
  lua_pushnumber(L, result);
  return 1;
}

static const luaL_Reg lib[] = {
  { "init",     f_init },
  { "close",    f_close },
  { "get_text", f_get_text },
  { "set_text", f_set_text },
  { NULL,       NULL }
};

LUALIB_API int luaopen_lclipboard(lua_State *L) {
  luaL_openlib(L, "clipboard", lib, 0);
  return 1;
}
