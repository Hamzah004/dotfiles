#!/bin/bash

PIDFILE="/tmp/wlsunset.pid"

if [[ -f "$PIDFILE" && -e /proc/$(cat "$PIDFILE") ]]; then
	kill "$(cat "$PIDFILE")"
	rm "$PIDFILE"
	echo '{"text": "🌞", "tooltip": "Night Light OFF"}'
else
	wlsunset -l 48.85 -L 2.35 & # Replace with your latitude/longitude
	echo $! >"$PIDFILE"
	echo '{"text": "🌙", "tooltip": "Night Light ON"}'
fi
