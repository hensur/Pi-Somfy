#!/bin/bash

ARGS=""

if [ "$ENABLE_MQTT" = "true" ]; then
    ARGS+="$ARGS -m"
fi

if [ "$ENABLE_ECHO" = "true" ]; then
    ARGS+="$ARGS -e"
fi


/usr/bin/python3 -u /opt/Pi-Somfy/operateShutters.py -c /config/pi-somfy.conf -a $ARGS