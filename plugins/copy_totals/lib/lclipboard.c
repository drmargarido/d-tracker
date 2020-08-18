#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"
#include "lclipboard.h"

// Manage clipboard
clipboard_c *cb;

void lclipboard_init(){
  cb = clipboard_new(NULL);
  if (cb == NULL) {
    printf("Clipboard initialization failed!\n");
  }
}

void lclipboard_close(){
  clipboard_free(cb);
}

// Lua bindings to Interact with the clipboard
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
  { "set_text", f_set_text },
  { NULL,       NULL }
};

LUALIB_API int luaopen_lclipboard(lua_State *L) {
  luaL_openlib(L, "clipboard", lib, 0);
  return 1;
}
