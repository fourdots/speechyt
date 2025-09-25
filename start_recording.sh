#!/bin/bash

# Lock file to prevent multiple concurrent recordings
LOCKFILE="$HOME/s2t/recording.lock"

# Check if already recording
if [ -f "$LOCKFILE" ]; then
    # Check if the process is still running
    if ps -p $(cat "$LOCKFILE" 2>/dev/null) > /dev/null 2>&1; then
        # Already recording, exit silently
        exit 0
    else
        # Stale lock file, remove it
        rm -f "$LOCKFILE"
    fi
fi

# Create lock file with current PID
echo $$ > "$LOCKFILE"

# Show notification that recording has started
notify-send "🎤 Recording..." "Speak now - release Ctrl+Space when done" -t 2000

# Start recording audio
rm -rf $HOME/s2t/tmp
mkdir -p $HOME/s2t/tmp
AUDIO_FILE="$HOME/s2t/tmp/recording.wav"
ffmpeg -f alsa -i default -ar 44100 -ac 2 $AUDIO_FILE &
FFMPEG_PID=$!
echo $FFMPEG_PID > $HOME/s2t/tmp/recording_pid

# Store both PIDs for cleanup
echo "$$ $FFMPEG_PID" > "$LOCKFILE"

