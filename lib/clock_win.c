#include <windows.h>
#include <stdio.h>
#include "clock.h"

lua_State *L;
unsigned int seconds = 0;
HANDLE thread = NULL;
int running = 0;

const char * TRIGGER_EVENT_CODE =
  "local event_manager = require \"src.plugin_manager.event_manager\""
  "local events = require \"src.plugin_manager.events\""
  "event_manager.fire_event(events.MINUTE_ELAPSED, {})";

DWORD WINAPI clock_proc(void* data) {
  while(running){
    Sleep(1000);
    seconds++;
    if(seconds >= 60){
      luaL_dostring(L, TRIGGER_EVENT_CODE);
      seconds = 0;
    }
  }
  return 0;
}

void clock_init(lua_State * state){
  L = state;
  seconds = 0;
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
