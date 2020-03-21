#!/bin/sh
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib/d-tracker
/usr/share/d-tracker/./d-tracker-cli $@
