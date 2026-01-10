#!/bin/bash

PIDFILE="/tmp/wlsunset.pid"

if [[ -f "$PIDFILE" && -e /proc/$(cat "$PIDFILE") ]]; then
	echo '{"text": "🌙", "tooltip": "Night Light ON"}'
else
	echo '{"text": "🌞", "tooltip": "Night Light OFF"}'
fi
