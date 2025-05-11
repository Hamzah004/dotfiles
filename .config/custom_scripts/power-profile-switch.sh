#!/bin/bash

current=${powerprofilectl get}

if [[ $current -eq "balanced" ]]; then
	powerprofilesctl set performance
elif [[ $current -eq "power-saver" ]]; then
	powerprofilesctl set performance
else
	powerprofilesctl set power-saver
