#!/bin/bash

# Lock file location
LOCKFILE="$HOME/s2t/recording.lock"

# Check if recording is actually happening
if [ ! -f "$LOCKFILE" ] || [ ! -f "$HOME/s2t/tmp/recording_pid" ]; then
    # No recording in progress, exit silently
    exit 0
fi

# Stop recording
kill $(cat $HOME/s2t/tmp/recording_pid 2>/dev/null) 2>/dev/null

# Remove lock file
rm -f "$LOCKFILE"

# Show processing notification
notify-send "⏳ Processing..." "Transcribing your speech to text" -t 2000

# Transcribe audio - FORCE ENGLISH LANGUAGE AND USE MEDIUM MODEL
source $HOME/env_sandbox/bin/activate
whisper $HOME/s2t/tmp/recording.wav --model medium --language en --output_dir="${HOME}/s2t/tmp/" --output_format="txt"
deactivate

# Temporary file for transcription
TRANSCRIPTION_FILE="$HOME/s2t/tmp/recording.txt"

# Copy transcription to clipboard
xclip -selection clipboard < $TRANSCRIPTION_FILE

# Optional: Notify the user that transcription is complete
notify-send "✅ Transcription Complete" "Text has been pasted at cursor location"

# Ensure the clipboard has time to update
sleep 0.1

# Simulate the paste action
xdotool key ctrl+v  # Use whichever key combination is appropriate

# Clean up
rm -rf $HOME/s2t/tmp/



