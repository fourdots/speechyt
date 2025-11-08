# 🚀 SpeechyT Quick Commands Cheatsheet

🆘 Emergency Reset

```bash
# Quick reset (use this first!)
./reset-speechyt.sh    # Fixes all state issues

# Reload keyboard shortcuts
./reload-bindings.sh   # Reloads xmodmap + xbindkeys

# Manual reset (if scripts don't work)
killall xbindkeys ffmpeg 2>/dev/null
rm -f ~/speechyt/recording.lock
rm -rf ~/speechyt/tmp/
mkdir -p ~/speechyt/tmp/
xbindkeys
echo "✅ Reset complete - try recording now"##
```

## 🎤 Recording Control

```bash
# Manual test (bypass mouse button)
cd /home/sho/Documents/dev-projects/speechyt && bash ./toggle_recording.sh

# Kill stuck recording
pkill -9 ffmpeg
rm -f /home/sho/Documents/dev-projects/speechyt/recording.lock /home/sho/Documents/dev-projects/speechyt/tmp/*

# Restart xbindkeys (mouse button not working)
cd /home/sho/Documents/dev-projects/speechyt && bash ./reload-bindings.sh
# OR
killall xbindkeys && xbindkeys

# Check if recording active
ps aux | grep ffmpeg | grep recording
```

## 📚 Dictionary Management

```bash
# View dictionary
cd /home/sho/Documents/dev-projects/speechyt && bash ./view-dictionary.sh
cd /home/sho/Documents/dev-projects/speechyt && bash ./view-dictionary.sh --all
cd /home/sho/Documents/dev-projects/speechyt && bash ./view-dictionary.sh --search "term"

# Edit dictionary
nano /home/sho/Documents/dev-projects/speechyt/dictionary.txt

# Import dictionary
cd /home/sho/Documents/dev-projects/speechyt && bash ./import-dictionary.sh ~/Downloads/dict.json

# Add single term (quick)
echo "myterm → MyTerm" >> /home/sho/Documents/dev-projects/speechyt/dictionary.txt
```

## 📜 History

```bash
# View transcription history
cd /home/sho/Documents/dev-projects/speechyt && bash ./view-history.sh

# Copy specific transcription to clipboard
cd /home/sho/Documents/dev-projects/speechyt && bash ./view-history.sh --copy 5

# Clear old history
rm /home/sho/Documents/dev-projects/speechyt/history/*.txt
```

## 🔧 Troubleshooting

```bash
# Full restart
killall xbindkeys ffmpeg 2>/dev/null
rm -f /home/sho/Documents/dev-projects/speechyt/recording.lock /home/sho/Documents/dev-projects/speechyt/tmp/*
xbindkeys

# Check status
pgrep xbindkeys    # Should return PID
ls /home/sho/Documents/dev-projects/speechyt/tmp/ # Should be empty if not recording

# Test recording manually
cd /home/sho/Documents/dev-projects/speechyt && bash ./toggle_recording.sh  # Start
# Speak...
cd /home/sho/Documents/dev-projects/speechyt && bash ./toggle_recording.sh  # Stop

# View errors
tail -50 ~/.xsession-errors | grep -i speech
```

## 🎯 Model Management

```bash
# Change model (edit toggle_recording.sh line 46)
nano /home/sho/Documents/dev-projects/speechyt/toggle_recording.sh
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
du -sh /home/sho/Documents/dev-projects/speechyt/tmp/*
ls -lh ~/.cache/whisper/  # Models

# Test whisper directly
source /home/sho/env_sandbox/bin/activate
whisper /home/sho/Documents/dev-projects/speechyt/tmp/recording.wav --model base.en --language en
deactivate

# Monitor live
watch -n 1 'ps aux | grep ffmpeg; ls -lh /home/sho/Documents/dev-projects/speechyt/tmp/ 2>/dev/null'
```

## 📊 Performance

```bash
# List downloaded models
ls -lh ~/.cache/whisper/

# Download model manually
source /home/sho/env_sandbox/bin/activate
whisper --model small.en --help  # Downloads on first use
deactivate
```

## 📁 File Locations

```
# Main SpeechyT directory (NEW location)
/home/sho/Documents/dev-projects/speechyt/

# Key files:
/home/sho/Documents/dev-projects/speechyt/toggle_recording.sh     # Main script
/home/sho/Documents/dev-projects/speechyt/double_tap_handler.sh   # Mouse trigger
/home/sho/Documents/dev-projects/speechyt/dictionary.txt          # Custom words
/home/sho/Documents/dev-projects/speechyt/history/                # Transcription history

# Utility scripts:
/home/sho/Documents/dev-projects/speechyt/reload-bindings.sh     # Reload xbindkeys
/home/sho/Documents/dev-projects/speechyt/reset-speechyt.sh      # Reset everything

# System configs:
~/.xbindkeysrc                    # Mouse button config
~/.cache/whisper/                 # AI models
/home/sho/env_sandbox/            # Python environment
```

## ⚡ Quick Fixes

```bash
# Recording won't start → Restart xbindkeys
killall xbindkeys && xbindkeys
# OR
cd /home/sho/Documents/dev-projects/speechyt && bash ./reload-bindings.sh

# Stuck recording → Kill ffmpeg
pkill -9 ffmpeg && rm -f /home/sho/Documents/dev-projects/speechyt/recording.lock

# Not pasting text → Check clipboard
xclip -selection clipboard -o

# Slow transcription → Use tiny.en model
nano /home/sho/Documents/dev-projects/speechyt/toggle_recording.sh  # Change model line 46

# Full reset (if everything breaks)
cd /home/sho/Documents/dev-projects/speechyt && bash ./reset-speechyt.sh
```
