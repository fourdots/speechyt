#!/bin/bash

# This script handles double-tap detection for speech-to-text
# Requires double-tap to start AND double-tap to stop recording

TAPFILE="$HOME/speechyt/last_tap_time"
RECORDING_STATE="$HOME/speechyt/recording.lock"
DOUBLE_TAP_THRESHOLD=0.5  # Maximum seconds between taps to count as double-tap

# Get current time in milliseconds
current_time=$(date +%s.%N)

# Check if this is part of a double-tap
if [ -f "$TAPFILE" ]; then
    last_tap=$(cat "$TAPFILE")
    # Calculate time difference
    time_diff=$(echo "$current_time - $last_tap" | bc)
    
    # Check if within double-tap threshold
    if (( $(echo "$time_diff < $DOUBLE_TAP_THRESHOLD" | bc -l) )); then
        # This is a double-tap! Execute the toggle
        rm -f "$TAPFILE"  # Clear the tap file
        
        # Call the actual toggle script
        /home/sho/speechyt/toggle_recording.sh
        exit 0
    fi
fi

# Not a double-tap yet, just record this tap time
echo "$current_time" > "$TAPFILE"

# Schedule cleanup of tap file after threshold expires
(sleep $DOUBLE_TAP_THRESHOLD && rm -f "$TAPFILE" 2>/dev/null) &
