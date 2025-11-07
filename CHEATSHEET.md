# 🚀 SpeechyT Quick Commands Cheatsheet

## 🎤 Recording Control

```bash
# Manual test (bypass mouse button)
bash ~/speechyt/toggle_recording.sh

# Kill stuck recording
pkill -9 ffmpeg
rm -f ~/speechyt/recording.lock ~/speechyt/tmp/*

# Restart xbindkeys (mouse button not working)
~/speechyt/reload-bindings.sh

killall xbindkeys && xbindkeys

# Check if recording active
ps aux | grep ffmpeg | grep recording
```

## 📚 Dictionary Management

```bash
# View dictionary
~/speechyt/view-dictionary.sh
~/speechyt/view-dictionary.sh --all
~/speechyt/view-dictionary.sh --search "term"

# Edit dictionary
nano ~/speechyt/dictionary.txt

# Import dictionary
~/speechyt/import-dictionary.sh ~/Downloads/dict.json

# Add single term (quick)
echo "myterm → MyTerm" >> ~/speechyt/dictionary.txt
```

## 📜 History

```bash
# View transcription history
~/speechyt/view-history.sh

# Copy specific transcription to clipboard
~/speechyt/view-history.sh --copy 5

# Clear old history
rm ~/speechyt/history/*.txt
```

## 🔧 Troubleshooting

```bash
# Full restart
killall xbindkeys ffmpeg 2>/dev/null
rm -f ~/speechyt/recording.lock ~/speechyt/tmp/*
xbindkeys

# Check status
pgrep xbindkeys    # Should return PID
ls ~/speechyt/tmp/ # Should be empty if not recording

# Test recording manually
bash ~/speechyt/toggle_recording.sh  # Start
# Speak...
bash ~/speechyt/toggle_recording.sh  # Stop

# View errors
tail -50 ~/.xsession-errors | grep -i speech
```

## 🎯 Model Management

```bash
# Change model (edit toggle_recording.sh line 31)
nano ~/speechyt/toggle_recording.sh
# Change: --model base.en

# Available models:
# tiny.en    (fastest, ~1s, good)
# base.en    (balanced, ~2s, better) ← current
# small.en   (slower, ~5s, very good)
# medium.en  (slow, ~15s, excellent)
```

## 🔍 Debug & Analysis

```bash
# Check file sizes
du -sh ~/speechyt/tmp/*
ls -lh ~/.cache/whisper/  # Models

# Test whisper directly
source ~/env_sandbox/bin/activate
whisper ~/speechyt/tmp/recording.wav --model base.en --language en
deactivate

# Monitor live
watch -n 1 'ps aux | grep ffmpeg; ls -lh ~/speechyt/tmp/ 2>/dev/null'
```

## 📊 Performance

```bash
# List downloaded models
ls -lh ~/.cache/whisper/

# Download model manually
source ~/env_sandbox/bin/activate
whisper --model small.en --help  # Downloads on first use
deactivate
```

## 🆘 Emergency Reset

```bash
# Quick reset (use this first!)
~/speechyt/reset-speechyt.sh    # Fixes all state issues

# Reload keyboard shortcuts
~/speechyt/reload-bindings.sh   # Reloads xmodmap + xbindkeys

# Manual reset (if scripts don't work)
killall xbindkeys ffmpeg 2>/dev/null
rm -f ~/speechyt/recording.lock
rm -rf ~/speechyt/tmp/
mkdir -p ~/speechyt/tmp/
xbindkeys
echo "✅ Reset complete - try recording now"
```

## 📁 File Locations

```
~/speechyt/toggle_recording.sh     # Main script
~/speechyt/double_tap_handler.sh   # Mouse trigger
~/speechyt/dictionary.txt          # Custom words
~/speechyt/history/               # Transcription history
~/.xbindkeysrc                    # Mouse button config
~/.cache/whisper/                 # AI models
```

## ⚡ Quick Fixes

```bash
# Recording won't start → Restart xbindkeys
killall xbindkeys && xbindkeys

# Stuck recording → Kill ffmpeg
pkill -9 ffmpeg && rm -f ~/speechyt/recording.lock

# Not pasting text → Check clipboard
xclip -selection clipboard -o

# Slow transcription → Use tiny.en model
nano ~/speechyt/toggle_recording.sh  # Change model
```
