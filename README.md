# SpeechyT 🎤 - Advanced Linux Speech-to-Text System

**Transform your speech into text instantly on Linux using OpenAI's Whisper - completely offline, no API keys required!**

SpeechyT is an enhanced fork of the original [s2t project](https://github.com/franchesoni/s2t) with significant improvements including double-tap activation (like Mac's Mr. Flow), mouse button support, multiple model options, and forced English transcription.

## ✨ Key Features

- **🎯 Double-tap activation**: Prevents accidental recordings (like Mac Mr. Flow)
- **🖱️ Mouse & keyboard support**: Use backtick key OR mouse side button
- **🚀 Ultra-fast transcription**: 2-5 seconds with optimized models
- **🔒 100% Private**: Runs completely offline, no data leaves your computer
- **🆓 No API keys**: Uses open-source Whisper models
- **📝 Auto-paste**: Transcribed text automatically appears at cursor
- **🔔 Visual notifications**: Clear feedback for all recording states
- **🛡️ Crash-proof**: Lock file system prevents multiple recordings

## 📋 Prerequisites

### System Requirements
- Ubuntu/Debian Linux (tested on Ubuntu 25.04)
- Python 3.8+
- Microphone/audio input device
- ~2GB disk space for models

### Required Packages
```bash
# Install system dependencies
sudo apt update
sudo apt install -y ffmpeg xclip xdotool xbindkeys python3-pip python3-venv git bc
```

## 🚀 Quick Installation

### 1. Clone the Repository
```bash
cd ~
git clone https://github.com/fourdots/speechyt.git
cd speechyt
```

### 2. Run the Installation Script
```bash
./install.sh
```

This will:
- Create Python virtual environment at `~/env_sandbox`
- Install OpenAI Whisper
- Download the base model (fastest)
- Configure xbindkeys
- Set up auto-start on login

### 3. Configure Key Bindings

The installer will create `~/.xbindkeysrc` with:
- **Backtick key (`)**: Double-tap to toggle recording
- **Mouse button 4**: Double-tap to toggle recording (side button)

### 4. Start the Service
```bash
# Start xbindkeys (or logout/login for auto-start)
xbindkeys
```

## 📖 Usage

### Double-Tap System (Like Mac Mr. Flow)
1. **Double-tap** backtick (`) or mouse button 4
2. See **"🎤 Recording Started"** notification
3. **Speak clearly** in English
4. **Double-tap** again to stop
5. See **"⏳ Processing..."** notification
6. **Text automatically appears** at cursor!

### Visual Feedback
- 🎤 **Recording Started**: Recording is active
- ⏳ **Processing...**: Transcribing your speech
- ✅ **Transcription Complete**: Text pasted at cursor
- ⚠️ **Failed**: If something went wrong

## ⚙️ Configuration Options

### Change Whisper Model

Edit `/home/sho/speechyt/toggle_recording.sh` and change the model:

| Model | Size | Speed | Accuracy | Use Case |
|-------|------|-------|----------|----------|
| `tiny` | 39MB | ~1-2s | Good | Quick notes |
| `base` | 74MB | ~2-5s | Better | **Default - balanced** |
| `small` | 461MB | ~5-10s | Very Good | Longer recordings |
| `medium` | 1.4GB | ~15-30s | Excellent | Professional use |
| `large` | 2.9GB | ~30-60s | Best | Maximum accuracy |

### Customize Double-Tap Timing

Edit `/home/sho/speechyt/double_tap_handler.sh`:
```bash
DOUBLE_TAP_THRESHOLD=0.5  # Seconds between taps (default: 0.5)
```

### Change Key Bindings

Edit `~/.xbindkeysrc` to use different keys:
```bash
# Example: Use F8 instead of backtick
"/home/sho/speechyt/double_tap_handler.sh"
    m:0x0 + c:74
    F8
```

Find keycodes with: `xev | grep keycode`

### Force Different Language

Edit `toggle_recording.sh` and change:
```bash
--language en  # Change to your language code (es, fr, de, etc.)
```

## 🔧 Troubleshooting

### Check if xbindkeys is running
```bash
pgrep -f xbindkeys
```

### Restart xbindkeys
```bash
killall xbindkeys && xbindkeys
```

### Test recording manually
```bash
# Start recording
./toggle_recording.sh
# Stop recording (run again)
./toggle_recording.sh
```

### Kill stuck recordings
```bash
pkill -f "ffmpeg.*recording.wav"
rm -f ~/speechyt/recording.lock
```

### View logs
```bash
# Run xbindkeys in verbose mode
xbindkeys -n -v
```

## 📁 File Structure

```
speechyt/
├── toggle_recording.sh        # Main recording/transcription logic
├── double_tap_handler.sh      # Double-tap detection
├── start_recording.sh         # Legacy: starts recording
├── stop_and_process_recording.sh  # Legacy: stops and transcribes
├── install.sh                 # Installation script
├── README.md                  # This file
└── .xbindkeysrc.example      # Example key binding configuration
```

## 🔄 Updates & Improvements

This enhanced version includes:
- **Double-tap activation** preventing accidental recordings
- **Mouse button support** for ergonomic use
- **Multiple model support** with easy switching
- **Forced English** transcription regardless of accent
- **Lock file system** preventing crashes from multiple processes
- **Comprehensive error handling** with user notifications
- **Optimized for speed** with base model as default

## 🤝 Contributing

Contributions are welcome! Please feel free to submit pull requests or open issues.

### Ideas for Future Improvements
- [ ] GPU acceleration support
- [ ] Multiple language simultaneous support
- [ ] Custom wake word activation
- [ ] Integration with voice commands
- [ ] Real-time transcription display
- [ ] Transcription history log

## 📜 License

MIT License - feel free to use and modify!

## 🙏 Credits

- Original [s2t project](https://github.com/franchesoni/s2t) by franchesoni
- Inspired by [nerd-dictation](https://github.com/ideasman42/nerd-dictation)
- Powered by [OpenAI Whisper](https://github.com/openai/whisper)

## 💡 Tips

- **Speak clearly** but naturally for best results
- **Minimize background noise** for better accuracy
- **Pause briefly** between sentences for better punctuation
- **Use headset mic** for consistent audio quality
- **Test different models** to find your speed/accuracy balance

---

**Enjoy hands-free typing with SpeechyT!** 🚀

*If this project helps you, consider starring ⭐ the repository!*
