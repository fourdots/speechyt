#!/bin/bash
# Quick test to see if xbindkeys detects your mouse button

echo "🖱️  Click mouse button 4 (side button) within 10 seconds..."
echo "If nothing happens, the button number might be different"
echo ""

timeout 10 xbindkeys -n -v 2>&1 | grep --line-buffered "button"
