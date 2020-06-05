#include "lua.h"
#include "lualib.h"
#include "lauxlib.h"

/*
  Clock runs as a separated thread and triggers an event of type MINUTE_ELAPSED
  to be used by the plugins.
*/

void clock_init(lua_State *L);
void clock_close();
