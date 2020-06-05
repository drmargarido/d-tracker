#include <stdio.h>
#include <unistd.h>
#include <pthread.h>
#include "clock.h"

lua_State *L;
unsigned int seconds = 0;
pthread_t thread;
int running = 0;

const char * TRIGGER_EVENT_CODE =
  "local event_manager = require \"src.plugin_manager.event_manager\" "
  "local events = require \"src.plugin_manager.events\" "
  "event_manager.fire_event(events.MINUTE_ELAPSED, {})";


void * clock_proc(void *ptr){
  while(running){
    usleep(1000000);
    seconds++;
    if(seconds >= 60){
      luaL_dostring(L, TRIGGER_EVENT_CODE);
      printf("Trigger MINUTE_ELAPSED event\n");
      seconds = 0;
    }
    printf("Elapsed seconds %d\n", seconds);
  }
}

void clock_init(lua_State * state){
  L = state;
  seconds = 0;
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
