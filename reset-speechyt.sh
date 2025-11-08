#!/bin/bash
# Reset SpeechyT when it gets confused about recording state

echo "🔄 Resetting SpeechyT state..."

# Kill any stuck ffmpeg processes
pkill -f "ffmpeg.*recording.wav" 2>/dev/null

# Clean up all temporary files and locks
rm -f ~/speechyt/recording.lock
rm -f ~/speechyt/tmp/recording_pid
rm -rf ~/speechyt/tmp/

# Clean up any stray tap files from double-tap handler
rm -f ~/speechyt/last_tap_time

echo "✅ SpeechyT reset complete!"
echo ""
echo "You can now use SpeechyT normally:"
echo "  • Mouse button 4 (double-tap)"
echo "  • Right Ctrl (double-tap)"
echo "  • GUI button in taskbar"

# Optional: restart xbindkeys to be sure
if pgrep -x "xbindkeys" > /dev/null; then
    echo ""
    echo "🔄 Restarting xbindkeys..."
    killall xbindkeys 2>/dev/null
    sleep 0.5
    xbindkeys
    echo "✅ xbindkeys restarted"
fi
