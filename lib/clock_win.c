#include <windows.h>
#include <stdio.h>
#include "clock.h"

#define SECOND 1000
#define MINUTE (60 * SECOND)

lua_State *L;
HANDLE thread = NULL;
int running = 0;

const char * TRIGGER_EVENT_CODE =
  "local event_manager = require \"src.plugin_manager.event_manager\""
  "local events = require \"src.plugin_manager.events\""
  "event_manager.fire_event(events.MINUTE_ELAPSED, {})";

DWORD WINAPI clock_proc(void* data) {
  while(running){
    Sleep(MINUTE);
    luaL_dostring(L, TRIGGER_EVENT_CODE);
  }
  return 0;
}

void clock_init(lua_State * state){
  L = state;
  running = 1;
  thread = CreateThread(NULL, 0, clock_proc, NULL, 0, NULL);
  if (!thread) {
    printf("Failed to init the clock.\n");
  }
}

void clock_close(){
  if(running){
    running = 0;
    CloseHandle(thread);
  }
}
