#!/bin/bash

# SpeechyT History Viewer
# View and copy previous transcriptions

HISTORY_DIR="$HOME/Documents/dev-projects/speechyt/history"

mkdir -p "$HISTORY_DIR"

echo "📜 SpeechyT Transcription History"
echo "================================="
echo ""

# Check for --copy flag
if [ "$1" == "--copy" ] && [ ! -z "$2" ]; then
    FILE=$(ls -t "$HISTORY_DIR"/*.txt 2>/dev/null | sed -n "${2}p")
    if [ -f "$FILE" ]; then
        cat "$FILE" | xclip -selection clipboard
        echo "✅ Copied transcription #$2 to clipboard!"
        cat "$FILE"
    else
        echo "❌ Transcription #$2 not found"
    fi
    exit 0
fi

# List recent transcriptions
FILES=$(ls -t "$HISTORY_DIR"/*.txt 2>/dev/null)

if [ -z "$FILES" ]; then
    echo "📭 No history yet. Record something first!"
    exit 0
fi

COUNT=1
echo "Recent transcriptions (newest first):"
echo "-------------------------------------"

while IFS= read -r file; do
    TIMESTAMP=$(basename "$file" .txt)
    CONTENT=$(cat "$file")
    PREVIEW=$(echo "$CONTENT" | head -c 100)
    
    echo ""
    echo "[$COUNT] $TIMESTAMP"
    echo "    $PREVIEW..."
    
    COUNT=$((COUNT + 1))
done <<< "$FILES"

echo ""
echo "-------------------------------------"
echo "💡 Usage:"
echo "   ~/speechyt/view-history.sh --copy 1   (copy #1 to clipboard)"
echo "   ~/speechyt/view-history.sh --copy 3   (copy #3 to clipboard)"
