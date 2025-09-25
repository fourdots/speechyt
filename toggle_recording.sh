#!/bin/bash

# Lock file to track recording state
LOCKFILE="$HOME/s2t/recording.lock"
PID_FILE="$HOME/s2t/tmp/recording_pid"

# Check if currently recording
if [ -f "$LOCKFILE" ] && [ -f "$PID_FILE" ]; then
    # Currently recording - STOP it
    
    # Kill the recording process
    FFMPEG_PID=$(cat "$PID_FILE" 2>/dev/null)
    if [ ! -z "$FFMPEG_PID" ]; then
        kill $FFMPEG_PID 2>/dev/null
        
        # Wait a moment for the recording to finish
        sleep 0.5
        
        # Show processing notification
        notify-send "⏳ Processing..." "Transcribing your speech to text" -t 2000
        
        # Check if recording file exists and has content
        if [ -f "$HOME/s2t/tmp/recording.wav" ]; then
            # Transcribe audio - FORCE ENGLISH LANGUAGE AND USE TINY MODEL (ultra-fast)
            source $HOME/env_sandbox/bin/activate
            whisper $HOME/s2t/tmp/recording.wav --model tiny --language en --output_dir="${HOME}/s2t/tmp/" --output_format="txt" 2>/dev/null
            deactivate
            
            # Temporary file for transcription
            TRANSCRIPTION_FILE="$HOME/s2t/tmp/recording.txt"
            
            if [ -f "$TRANSCRIPTION_FILE" ]; then
                # Copy transcription to clipboard
                xclip -selection clipboard < $TRANSCRIPTION_FILE
                
                # Notify completion
                notify-send "✅ Transcription Complete" "Text has been pasted at cursor location"
                
                # Ensure the clipboard has time to update
                sleep 0.1
                
                # Simulate the paste action
                xdotool key ctrl+v
            else
                notify-send "⚠️ Transcription Failed" "No text was transcribed"
            fi
        else
            notify-send "⚠️ Recording Failed" "No audio was recorded"
        fi
        
        # Clean up
        rm -rf $HOME/s2t/tmp/
        rm -f "$LOCKFILE"
    fi
else
    # Not recording - START it
    
    # Clean any old files first
    rm -rf $HOME/s2t/tmp
    mkdir -p $HOME/s2t/tmp
    
    # Show notification that recording has started
    notify-send "🎤 Recording Started" "Double-tap backtick or mouse button to stop" -t 2000
    
    # Start recording audio in background
    AUDIO_FILE="$HOME/s2t/tmp/recording.wav"
    ffmpeg -f alsa -i default -ar 44100 -ac 2 "$AUDIO_FILE" > /dev/null 2>&1 &
    FFMPEG_PID=$!
    
    # Save the PID
    echo $FFMPEG_PID > "$PID_FILE"
    
    # Create lock file
    echo $FFMPEG_PID > "$LOCKFILE"
fi
