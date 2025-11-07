#!/bin/bash
# SpeechyT GUI Button - Click to toggle recording

LOCKFILE="$HOME/speechyt/recording.lock"

if [ -f "$LOCKFILE" ]; then
    # Currently recording - stop it
    notify-send "🛑 SpeechyT" "Stopping recording..." -t 1000
    bash "$HOME/speechyt/toggle_recording.sh"
else
    # Not recording - start it
    notify-send "🎤 SpeechyT" "Starting recording..." -t 1000
    bash "$HOME/speechyt/toggle_recording.sh"
fi
