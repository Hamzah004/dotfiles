#!/bin/sh

# Function to start timer
start_timer() {
    minutes="$1"
    if [ -z "$minutes" ] || ! echo "$minutes" | grep -q '^[0-9]\+$' || [ "$minutes" -lt 1 ]; then
        notify-send "Timer" "Invalid input. Please enter a valid number of minutes (minimum 1)."
        return 1
    fi

    end_time=$(($(date +%s) + minutes * 60))
    echo "$end_time" > /var/tmp/waybar_timer
    notify-send "Timer" "Timer set for $minutes minute(s)"
}

# Function to stop timer
stop_timer() {
    echo "READY" > /var/tmp/waybar_timer
    notify-send "Timer" "Timer stopped"
}

# Check current status
STATUS=$(cat /var/tmp/waybar_timer 2>/dev/null || echo "READY")
CUR_TIME=$(date +%s)

if [ "$STATUS" != "READY" ] && [ "$STATUS" != "FINISHED" ] && [ "$STATUS" -gt "$CUR_TIME" ] 2>/dev/null; then
    REMAINING=$((STATUS - CUR_TIME))
    REMAINING_MIN=$((REMAINING / 60))
    REMAINING_SEC=$((REMAINING % 60))
    CURRENT_STATUS="Timer running: ${REMAINING_MIN}m ${REMAINING_SEC}s remaining"
else
    CURRENT_STATUS="No active timer"
fi

# Create GUI dialog
ACTION=$(zenity --list \
    --title="Timer Control" \
    --text="Current status: $CURRENT_STATUS" \
    --column="Action" \
    "Start new timer" \
    "Stop current timer" \
    --height=250 \
    --width=300 2>/dev/null)

case "$ACTION" in
    "Start new timer")
        MINUTES=$(zenity --entry \
            --title="Set Timer" \
            --text="Enter timer duration in minutes:" \
            --entry-text="5" 2>/dev/null)
        if [ $? -eq 0 ] && [ -n "$MINUTES" ]; then
            start_timer "$MINUTES"
        fi
        ;;
    "Stop current timer")
        stop_timer
        ;;
    *)
        exit 0
        ;;
esac