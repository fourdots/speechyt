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
            
            # Set library path for cuDNN (required for GPU)
            export LD_LIBRARY_PATH=$HOME/env_sandbox/lib/python3.13/site-packages/nvidia/cudnn/lib:$LD_LIBRARY_PATH
            
            # Initial prompt helps Whisper recognize technical terms
            INITIAL_PROMPT="Technical terms: SpeechyT, Fantom, fantomWorks, OctoBrowser, Supabase, ScrapingBee, AdsPower, FireSearch, Windsurf, OpenMemory, Crawl4AI, Pinecone, BullMQ, Claude, OpenAI, OAuth, AHREFS, Cline, Radomir Basta, Four Dots, fourdots.com"
            
            # Using faster-whisper with GPU acceleration (5-10x faster!)
            # Custom Python CLI with device=cuda and compute_type=float16 for RTX GPUs
            python3 "${HOME}/speechyt/faster_whisper_cli.py" \
                --model base.en \
                --language en \
                --device cuda \
                --compute_type float16 \
                --initial_prompt "$INITIAL_PROMPT" \
                --output_dir "${HOME}/speechyt/tmp/" \
                --output_format txt \
                "${HOME}/speechyt/tmp/recording.wav"
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
                
                # Save to history (last 20 transcriptions)
                HISTORY_DIR="$HOME/speechyt/history"
                mkdir -p "$HISTORY_DIR"
                TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
                cp "$TRANSCRIPTION_FILE" "$HISTORY_DIR/${TIMESTAMP}.txt"
                
                # Keep only last 20 files
                ls -t "$HISTORY_DIR"/*.txt 2>/dev/null | tail -n +21 | xargs -r rm
                
                # Get the target window ID that was saved when recording started
                ACTIVE_WINDOW=$(cat "$HOME/speechyt/tmp/target_window_id" 2>/dev/null)
                
                # Copy transcription to clipboard
                xclip -selection clipboard < $TRANSCRIPTION_FILE
                
                # Notify completion
                notify-send "✅ Transcription Complete" "Text pasted!" -t 1000
                
                # Minimal delay for clipboard to settle (GPU is fast!)
                sleep 0.1
                
                # Restore focus to the original window (saved when recording started)
                if [ ! -z "$ACTIVE_WINDOW" ]; then
                    xdotool windowactivate --sync $ACTIVE_WINDOW 2>/dev/null
                    sleep 0.05
                    
                    # Simulate the paste action
                    xdotool key --clearmodifiers ctrl+v
                fi
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
    
    # IMPORTANT: Save the currently active window ID NOW (before notifications change focus)
    ACTIVE_WINDOW=$(xdotool getactivewindow 2>/dev/null)
    echo "$ACTIVE_WINDOW" > "$HOME/speechyt/tmp/target_window_id"
    
    # Create lock file
    echo "$$" > "$LOCKFILE"
    
    # Show notification
    notify-send "🎤 Recording Started" "Double-tap mouse button 4 to stop" -t 2000
    
    # Create temporary directory
    mkdir -p $HOME/speechyt/tmp/
    
    # Start recording with ffmpeg (in background)
    ffmpeg -f alsa -i default -ar 44100 -ac 2 $HOME/speechyt/tmp/recording.wav &
    FFMPEG_PID=$!
    
    # Save the PID
    echo $FFMPEG_PID > "$PID_FILE"
fi
