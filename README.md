# SpeechyT 🎤 - Fast, Private Speech-to-Text for Linux

**Transform your speech into text instantly on Linux using faster-whisper - completely offline, no API keys required!**

SpeechyT is a production-ready speech-to-text solution with faster-whisper engine (2-4x faster than standard Whisper), custom dictionary support, and seamless auto-paste functionality.

## ✨ Key Features

- **⚡ Blazing Fast**: 1-2 second transcription with faster-whisper (2-4x faster than openai-whisper)
- **🎯 Three Control Methods**: Mouse button 4, Right Ctrl key, or GUI taskbar button
- **📚 Custom Dictionary**: 148+ technical terms auto-corrected (add your own!)
- **📜 Transcription History**: Auto-saves last 20 transcriptions with timestamps
- **🍎 Mac Keyboard Support**: Works with Mac-style keyboard remapping (Alt=Ctrl)
- **🪟 Smart Window Focus**: Auto-pastes at cursor even if windows pop up during transcription
- **🔒 100% Private**: Runs completely offline, no data leaves your computer
- **🆓 No API Keys**: Uses open-source Whisper models
- **📝 Auto-paste**: Transcribed text automatically appears at cursor
- **🔔 Visual Notifications**: Clear feedback for all recording states

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

### Three Ways to Record

**Method 1: Mouse Button 4**
- Double-tap side button → Start recording
- Double-tap again → Stop & paste

**Method 2: Right Ctrl Key**
- Double-tap Right Ctrl → Start recording
- Double-tap again → Stop & paste

**Method 3: GUI Button (Taskbar)**
- Click SpeechyT icon → Start recording
- Click again → Stop & paste
- Find in app menu: Search "SpeechyT" → Pin to taskbar

### Recording Flow
1. Trigger recording (any method above)
2. See **"🎤 Recording Started"** notification
3. **Speak clearly** in English
4. Trigger again to stop
5. See **"⏳ Processing..."** notification (1-2 seconds)
6. **Text automatically pastes** at cursor!

### Visual Feedback
- 🎤 **Recording Started**: Recording is active
- ⏳ **Processing...**: Transcribing your speech
- ✅ **Transcription Complete**: Text pasted at cursor
- ⚠️ **Failed**: If something went wrong

## ⚙️ Configuration Options

### Custom Dictionary

Add technical terms, company names, and custom words:

```bash
# Create your personal dictionary from the example
cp ~/speechyt/dictionary.txt.example ~/speechyt/dictionary.txt

# Edit dictionary
nano ~/speechyt/dictionary.txt

# Add entries (format: wrong → correct)
kubernetes → Kubernetes
postgresql → PostgreSQL
mycompany → MyCompany
```

**Note:** Your `dictionary.txt` is excluded from git to keep your personal terms private.

**Import from Wispr Flow (Mac):**
```bash
~/speechyt/import-dictionary.sh ~/Downloads/wispr-dictionary.json
```

Supports: JSON, CSV, TXT formats

### View Transcription History

```bash
# View recent transcriptions
~/speechyt/view-history.sh

# Copy specific transcription to clipboard
~/speechyt/view-history.sh --copy 1
```

Automatically saves last 20 transcriptions with timestamps.

### Change Whisper Model

Edit `~/speechyt/toggle_recording.sh` line 31 and change the model:

| Model | Size | Speed | Accuracy | Use Case |
|-------|------|-------|----------|----------|
| `tiny.en` | 39MB | ~0.5-1s | Good | Ultra-fast notes |
| `base.en` | 74MB | ~1-2s | Better | **Default - balanced** |
| `small.en` | 461MB | ~3-5s | Very Good | Longer recordings |
| `medium.en` | 1.4GB | ~10-15s | Excellent | Professional use |
| `large` | 2.9GB | ~20-30s | Best | Maximum accuracy |

**Note:** Using faster-whisper engine (2-4x faster than openai-whisper). `.en` models are optimized for English.

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

### Quick Fix (Shortcuts Not Working)
```bash
~/speechyt/reload-bindings.sh
```
This reloads both xmodmap (keyboard remapping) and xbindkeys (mouse buttons).

### Check if xbindkeys is running
```bash
pgrep -f xbindkeys
```

### Restart xbindkeys
```bash
killall xbindkeys && xbindkeys
```

### GUI Button Not Appearing
```bash
update-desktop-database ~/.local/share/applications/
```
Then search for "SpeechyT" in app menu.

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

### See Available Commands
```bash
cat ~/speechyt/CHEATSHEET.md
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
