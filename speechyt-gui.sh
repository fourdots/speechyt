#!/bin/bash
# SpeechyT GUI Button - Click to toggle recording

# Set flag to skip auto-paste (clicking taskbar changes window focus)
# User can manually paste with Alt+V after clicking back to their window
export NO_AUTO_PASTE=1

# Call toggle_recording.sh
bash "$HOME/speechyt/toggle_recording.sh"
