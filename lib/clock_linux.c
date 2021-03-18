#include <stdio.h>
#include <unistd.h>
#include <pthread.h>
#include "clock.h"

#define SECOND 1000000
#define MINUTE (60 * SECOND)

lua_State *L;
pthread_t thread;
int running = 0;

const char * TRIGGER_EVENT_CODE =
  "local event_manager = require \"src.plugin_manager.event_manager\""
  "local events = require \"src.plugin_manager.events\""
  "event_manager.fire_event(events.MINUTE_ELAPSED, {})";

void * clock_proc(void *ptr){
  while(running){
    usleep(MINUTE);
    luaL_dostring(L, TRIGGER_EVENT_CODE);
  }
}

void clock_init(lua_State * state){
  L = state;
  running = 1;
  int result = pthread_create(&thread, NULL, clock_proc, (void*) NULL);
  if(result != 0){
    printf("Failed to init the clock.\n");
  }
}

void clock_close(){
  if(running){
    running = 0;
    pthread_join(thread, NULL);
  }
}
