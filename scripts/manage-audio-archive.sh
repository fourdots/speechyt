#!/bin/bash
# Manage audio archive - view, clean, or export recordings

AUDIO_ARCHIVE="$HOME/Documents/dev-projects/speechyt/audio_archive"

show_help() {
    echo "🎤 Audio Archive Manager"
    echo "======================="
    echo ""
    echo "Usage: $0 [command]"
    echo ""
    echo "Commands:"
    echo "  list       - List all archived recordings"
    echo "  count      - Show total recordings and size"
    echo "  clean      - Delete all archived recordings"
    echo "  old [days] - Delete recordings older than N days (default: 30)"
    echo "  export     - Copy all recordings to ~/Desktop/speechyt_audio/"
    echo ""
}

case "$1" in
    list)
        if [ -d "$AUDIO_ARCHIVE" ]; then
            echo "📁 Archived recordings (paired audio + transcription):"
            echo ""
            for wav in "$AUDIO_ARCHIVE"/*.wav 2>/dev/null; do
                if [ -f "$wav" ]; then
                    basename="${wav%.wav}"
                    txt="${basename}.txt"
                    size=$(du -h "$wav" | cut -f1)
                    timestamp=$(basename "$basename")
                    
                    if [ -f "$txt" ]; then
                        preview=$(head -c 50 "$txt" 2>/dev/null)
                        echo "🎙️  $timestamp ($size)"
                        echo "   📝 \"${preview}...\""
                        echo ""
                    else
                        echo "🎙️  $timestamp ($size) - ⚠️ missing transcription"
                        echo ""
                    fi
                fi
            done
        else
            echo "No recordings archived yet"
        fi
        ;;
    
    count)
        if [ -d "$AUDIO_ARCHIVE" ]; then
            WAV_COUNT=$(ls -1 "$AUDIO_ARCHIVE"/*.wav 2>/dev/null | wc -l)
            TXT_COUNT=$(ls -1 "$AUDIO_ARCHIVE"/*.txt 2>/dev/null | wc -l)
            SIZE=$(du -sh "$AUDIO_ARCHIVE" 2>/dev/null | cut -f1)
            PAIRED=$((WAV_COUNT < TXT_COUNT ? WAV_COUNT : TXT_COUNT))
            echo "📊 Archive Statistics:"
            echo "   Audio files: $WAV_COUNT"
            echo "   Transcriptions: $TXT_COUNT"
            echo "   Paired recordings: $PAIRED"
            echo "   Total size: $SIZE"
        else
            echo "No recordings archived yet"
        fi
        ;;
    
    clean)
        read -p "⚠️  Delete ALL archived recordings? (y/N) " -r
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            rm -rf "$AUDIO_ARCHIVE"
            echo "✅ Archive cleaned"
        else
            echo "Cancelled"
        fi
        ;;
    
    old)
        DAYS=${2:-30}
        if [ -d "$AUDIO_ARCHIVE" ]; then
            find "$AUDIO_ARCHIVE" -name "*.wav" -type f -mtime +$DAYS -delete
            echo "✅ Deleted recordings older than $DAYS days"
        else
            echo "No archive to clean"
        fi
        ;;
    
    export)
        EXPORT_DIR="$HOME/Desktop/speechyt_audio"
        mkdir -p "$EXPORT_DIR"
        if [ -d "$AUDIO_ARCHIVE" ]; then
            cp "$AUDIO_ARCHIVE"/*.wav "$EXPORT_DIR/" 2>/dev/null
            cp "$AUDIO_ARCHIVE"/*.txt "$EXPORT_DIR/" 2>/dev/null
            WAV_COUNT=$(ls -1 "$EXPORT_DIR"/*.wav 2>/dev/null | wc -l)
            TXT_COUNT=$(ls -1 "$EXPORT_DIR"/*.txt 2>/dev/null | wc -l)
            echo "✅ Exported to $EXPORT_DIR"
            echo "   Audio files: $WAV_COUNT"
            echo "   Transcriptions: $TXT_COUNT"
        else
            echo "No recordings to export"
        fi
        ;;
    
    *)
        show_help
        ;;
esac
