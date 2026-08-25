#!/bin/bash

if pidof gammastep >/dev/null; then
	pkill -x gammastep
else
	gammastep -m wayland -O 2300 &
fi
