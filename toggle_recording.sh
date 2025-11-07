#!/bin/bash

# Lock file to track recording state
LOCKFILE="$HOME/speechyt/recording.lock"
PID_FILE="$HOME/speechyt/tmp/recording_pid"

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
        if [ -f "$HOME/speechyt/tmp/recording.wav" ]; then
            # Transcribe audio - FORCE ENGLISH LANGUAGE AND USE FASTER-WHISPER (2-4x faster!)
            source $HOME/env_sandbox/bin/activate
            
            # Initial prompt helps Whisper recognize technical terms
            INITIAL_PROMPT="Technical terms: SpeechyT, Fantom, OctoBrowser, Laravel, Puppeteer, Evomi, DataImpulse, faster-whisper"
            
            # Using faster-whisper CLI with base.en model (optimized for English)
            whisper --model base.en --language en --initial_prompt "$INITIAL_PROMPT" --output_dir "${HOME}/speechyt/tmp/" --output_format txt "$HOME/speechyt/tmp/recording.wav" 2>/dev/null
            deactivate
            
            # Temporary file for transcription
            TRANSCRIPTION_FILE="$HOME/speechyt/tmp/recording.txt"
            
            if [ -f "$TRANSCRIPTION_FILE" ]; then
                # Apply custom dictionary replacements (if dictionary exists)
                if [ -f "$HOME/speechyt/dictionary.txt" ]; then
                    # Read dictionary and apply replacements
                    while IFS='→' read -r wrong correct; do
                        # Skip comments and empty lines
                        [[ "$wrong" =~ ^#.*$ ]] && continue
                        [[ -z "$wrong" ]] && continue
                        
                        # Trim whitespace (without xargs to avoid quote issues)
                        wrong="${wrong#"${wrong%%[![:space:]]*}"}"
                        wrong="${wrong%"${wrong##*[![:space:]]}"}"
                        correct="${correct#"${correct%%[![:space:]]*}"}"
                        correct="${correct%"${correct##*[![:space:]]}"}"
                        
                        # Skip if empty after trimming
                        [[ -z "$wrong" ]] || [[ -z "$correct" ]] && continue
                        
                        # Apply case-insensitive replacement
                        sed -i "s/\b${wrong}\b/${correct}/gI" "$TRANSCRIPTION_FILE" 2>/dev/null
                    done < "$HOME/speechyt/dictionary.txt"
                fi
                
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
        rm -rf $HOME/speechyt/tmp/
        rm -f "$LOCKFILE"
    fi
else
    # Not recording - START it
    
    # Clean any old files first
    rm -rf $HOME/speechyt/tmp
    mkdir -p $HOME/speechyt/tmp
    
    # Show notification that recording has started
    notify-send "🎤 Recording Started" "Double-tap mouse button 4 to stop" -t 2000
    
    # Start recording audio in background
    AUDIO_FILE="$HOME/speechyt/tmp/recording.wav"
    ffmpeg -f alsa -i default -ar 44100 -ac 2 "$AUDIO_FILE" > /dev/null 2>&1 &
    FFMPEG_PID=$!
    
    # Save the PID
    echo $FFMPEG_PID > "$PID_FILE"
    
    # Create lock file
    echo $FFMPEG_PID > "$LOCKFILE"
fi
