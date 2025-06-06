#!/bin/sh

CUR_TIME=$(date +%s)
STATUS=$(cat /var/tmp/waybar_timer)

if [ "$STATUS" = "READY" ]; then
	echo ""
elif [ "$STATUS" = "FINISHED" ]; then
	mpv "$HOME/.config/waybar/timer.mp3" &
	echo "READY" >/var/tmp/waybar_timer
	echo ""
elif [ "$STATUS" -gt "$CUR_TIME" ] 2>/dev/null; then
	DIFF=$((STATUS - CUR_TIME))
	echo "$(date -d "@$DIFF" +%M:%S)"
else
	if [ -f "/var/tmp/waybar_timer" ]; then
		echo "FINISHED" >/var/tmp/waybar_timer
		echo ""
	else
		echo "READY" >/var/tmp/waybar_timer
		echo ""
	fi
fi
