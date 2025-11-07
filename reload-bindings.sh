#!/bin/bash
# Reload keyboard remapping and xbindkeys
# Run this if shortcuts stop working

echo "🔄 Reloading keyboard configuration..."

# Reload xmodmap (Alt = Ctrl remapping)
if [ -f ~/.Xmodmap ]; then
    xmodmap ~/.Xmodmap
    echo "✅ Xmodmap reloaded"
fi

# Restart xbindkeys (mouse buttons and shortcuts)
killall xbindkeys 2>/dev/null
sleep 0.2
xbindkeys
echo "✅ Xbindkeys restarted"

echo ""
echo "🎯 All shortcuts should work now:"
echo "   - Mouse button 4: Double-tap to record"
echo "   - Right Ctrl: Double-tap to record"
echo "   - Alt+C/V/X: Copy/Paste/Cut"
