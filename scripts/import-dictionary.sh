#!/bin/bash

# SpeechyT Dictionary Import Tool
# Imports dictionaries from various formats (Wispr Flow, JSON, CSV, TXT)

DICT_FILE="$HOME/Documents/dev-projects/speechyt/dictionary.txt"
BACKUP_FILE="$HOME/Documents/dev-projects/speechyt/dictionary.backup.txt"

echo "📚 SpeechyT Dictionary Import Tool"
echo "=================================="
echo ""

# Check if file argument provided
if [ -z "$1" ]; then
    echo "Usage: $0 <dictionary-file>"
    echo ""
    echo "Supported formats:"
    echo "  - Wispr Flow export (JSON)"
    echo "  - CSV (wrong,correct)"
    echo "  - Text (wrong → correct)"
    echo "  - Plain text (one term per line, auto-capitalizes)"
    echo ""
    echo "Example:"
    echo "  $0 ~/Downloads/whispr-flow-dictionary.json"
    echo "  $0 ~/Downloads/my-terms.csv"
    echo "  $0 ~/Downloads/technical-terms.txt"
    exit 1
fi

IMPORT_FILE="$1"

# Check if import file exists
if [ ! -f "$IMPORT_FILE" ]; then
    echo "❌ Error: File not found: $IMPORT_FILE"
    exit 1
fi

# Backup existing dictionary
if [ -f "$DICT_FILE" ]; then
    cp "$DICT_FILE" "$BACKUP_FILE"
    echo "✅ Backed up existing dictionary to: $BACKUP_FILE"
fi

# Detect file format
EXTENSION="${IMPORT_FILE##*.}"

echo "📁 Import file: $IMPORT_FILE"
echo "📋 Format: $EXTENSION"
echo ""

# Process based on format
case "$EXTENSION" in
    json)
        echo "🔄 Processing JSON format (Wispr Flow style)..."
        
        # Try to extract dictionary entries from JSON
        # Wispr Flow typically stores as {"word": "replacement", ...}
        if command -v jq &> /dev/null; then
            # Use jq if available
            jq -r 'to_entries[] | "\(.key) → \(.value)"' "$IMPORT_FILE" >> "$DICT_FILE"
        else
            # Fallback: simple grep/sed parsing
            grep -oP '"[^"]+"\s*:\s*"[^"]+"' "$IMPORT_FILE" | \
            sed 's/"\([^"]*\)"\s*:\s*"\([^"]*\)"/\1 → \2/g' >> "$DICT_FILE"
        fi
        ;;
    
    csv)
        echo "🔄 Processing CSV format..."
        
        # Convert CSV to dictionary format
        while IFS=',' read -r wrong correct; do
            # Skip header if exists
            [[ "$wrong" =~ ^(wrong|from|source|original) ]] && continue
            
            # Clean and add
            wrong=$(echo "$wrong" | xargs | tr -d '"')
            correct=$(echo "$correct" | xargs | tr -d '"')
            
            if [ ! -z "$wrong" ] && [ ! -z "$correct" ]; then
                echo "$wrong → $correct" >> "$DICT_FILE"
            fi
        done < "$IMPORT_FILE"
        ;;
    
    txt|text)
        echo "🔄 Processing text format..."
        
        # Check if already in arrow format
        if grep -q '→' "$IMPORT_FILE"; then
            # Already in correct format, just append
            cat "$IMPORT_FILE" >> "$DICT_FILE"
        else
            # Simple word list - auto-capitalize first letter
            while read -r word; do
                # Skip empty lines and comments
                [[ -z "$word" ]] && continue
                [[ "$word" =~ ^#.*$ ]] && continue
                
                # Auto-capitalize first letter
                lowercase=$(echo "$word" | tr '[:upper:]' '[:lower:]')
                capitalized=$(echo "$word" | sed 's/\b\(.\)/\u\1/')
                
                # Add both lower → capitalized
                echo "$lowercase → $capitalized" >> "$DICT_FILE"
            done < "$IMPORT_FILE"
        fi
        ;;
    
    *)
        echo "⚠️  Unknown format, trying as plain text..."
        cat "$IMPORT_FILE" >> "$DICT_FILE"
        ;;
esac

# Remove duplicates and sort
if [ -f "$DICT_FILE" ]; then
    sort -u "$DICT_FILE" -o "$DICT_FILE"
    
    # Count entries
    ENTRIES=$(grep -c '→' "$DICT_FILE" 2>/dev/null || echo 0)
    
    echo ""
    echo "✅ Import complete!"
    echo "📊 Total dictionary entries: $ENTRIES"
    echo "📂 Dictionary location: $DICT_FILE"
    echo "💾 Backup saved to: $BACKUP_FILE"
    echo ""
    echo "🎯 Test it now by recording some speech!"
fi
