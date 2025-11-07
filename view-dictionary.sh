#!/bin/bash

# SpeechyT Dictionary Viewer
# Quick view of your current dictionary

DICT_FILE="$HOME/Documents/dev-projects/speechyt/dictionary.txt"

echo "📚 SpeechyT Dictionary Viewer"
echo "=============================="
echo ""

if [ ! -f "$DICT_FILE" ]; then
    echo "❌ No dictionary found at: $DICT_FILE"
    exit 1
fi

# Count total entries
TOTAL=$(grep -c '→' "$DICT_FILE" 2>/dev/null || echo 0)

echo "📊 Total entries: $TOTAL"
echo ""

# Show options
if [ "$1" == "--all" ] || [ "$1" == "-a" ]; then
    echo "📋 All dictionary entries:"
    echo "-------------------------"
    cat "$DICT_FILE"
elif [ "$1" == "--search" ] || [ "$1" == "-s" ]; then
    if [ -z "$2" ]; then
        echo "Usage: $0 --search <term>"
        exit 1
    fi
    echo "🔍 Searching for: $2"
    echo "-------------------------"
    grep -i "$2" "$DICT_FILE"
else
    echo "📋 First 20 entries (use --all to see everything):"
    echo "-------------------------"
    grep '→' "$DICT_FILE" | grep -v '^#' | head -20
    
    if [ $TOTAL -gt 20 ]; then
        echo ""
        echo "... and $(($TOTAL - 20)) more entries"
        echo ""
        echo "💡 Use: $0 --all      (show all)"
        echo "💡 Use: $0 --search <term>  (search)"
    fi
fi

echo ""
echo "📂 Dictionary location: $DICT_FILE"
echo "✏️  Edit: nano $DICT_FILE"
