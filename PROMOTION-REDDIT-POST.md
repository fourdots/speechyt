# [Title] SpeechyT: Fast, offline speech-to-text for Linux with custom dictionary and history (MIT license)

## Post for r/linux or r/opensource

Hey r/linux! 👋

I got tired of the lack of good speech-to-text options on Linux, so I built **SpeechyT** — a fast, offline, privacy-respecting dictation tool that actually works.

### TL;DR
- **1-2 second transcriptions** (faster-whisper, not standard Whisper)
- **100% offline** (no API keys, no cloud, no tracking)
- **Custom dictionary** (finally, `kubernetes → Kubernetes` works)
- **Transcription history** (auto-saves last 20)
- **Mouse button trigger** (double-tap side button → speak → double-tap)
- **MIT licensed** and open source

### Why Another Speech-to-Text Tool?

Because existing options suck for Linux:
- **Cloud services**: Require API keys, cost money, privacy concerns
- **Nerd Dictation**: Good but slow (standard Whisper)
- **Commercial apps**: Mac/Windows only, or buggy Linux ports
- **Browser extensions**: Need internet, limited functionality

I wanted something that felt like Wispr Flow on Mac but actually respected my privacy and didn't require a subscription.

### Key Features

**⚡ Fast:** Using `faster-whisper` (C++ optimized), transcription takes 1-2 seconds vs 3-5 seconds with standard Whisper. That's a big deal when you're dictating frequently.

**🎯 Smart Dictionary:** Add technical terms once, they're corrected forever:
```bash
# Edit ~/speechyt/dictionary.txt
kubernetes → Kubernetes
postgresql → PostgreSQL
fastapi → FastAPI
```

Two-layer system: helps Whisper recognize terms + post-processing replacements.

**📜 History:** Never lose a transcription. Auto-saves last 20 with timestamps:
```bash
~/speechyt/view-history.sh          # View history
~/speechyt/view-history.sh --copy 1 # Copy #1 to clipboard
```

**🖱️ Simple UX:** Double-tap mouse button 4 (side button) → speak → double-tap again → text appears. No GUI, no complexity.

### Installation (Ubuntu/Debian)

```bash
sudo apt install ffmpeg xclip xdotool xbindkeys python3-pip python3-venv git bc
cd ~ && git clone https://github.com/fourdots/speechyt.git
cd speechyt && ./install.sh
```

Downloads ~74MB model, sets up Python env, configures hotkeys. Takes ~5 minutes.

### Performance

Running on a mid-range laptop (i7, 16GB RAM):
- **Transcription:** 1-2 seconds for typical sentences
- **Accuracy:** 95%+ with tuned dictionary
- **CPU usage:** ~30-50% during transcription (2-3 seconds)
- **Memory:** ~200MB when idle, ~500MB during transcription

Using `base.en` model (English only). Other models available:
- `tiny.en`: Ultra fast (~0.5-1s), good accuracy
- `small.en`: Slower (~3-5s), better accuracy
- `medium.en`: Much slower (~15s), excellent accuracy

### What It's NOT

Let's be clear:
- **Not real-time** (record → transcribe, not streaming)
- **Not multilingual** (English-only by design)
- **Not voice commands** (pure dictation)
- **Not GPU-optimized** yet (CPU only currently)

### Comparison

| Feature | SpeechyT | Nerd Dictation | Commercial |
|---------|----------|----------------|------------|
| Speed | 1-2s | 3-5s | 1-3s |
| Offline | Yes | Yes | Usually no |
| Dictionary | Yes | Limited | Sometimes |
| History | Yes | No | Varies |
| Cost | Free | Free | $5-20/mo |

### Roadmap

- GPU acceleration (CUDA/ROCm)
- Multiple languages
- Voice commands integration
- Real-time streaming mode

### Links

**GitHub:** https://github.com/fourdots/speechyt
**Issues:** https://github.com/fourdots/speechyt/issues
**License:** MIT

### Try It

Clone it, run `./install.sh`, and try it for 5 minutes. If it works for you, star the repo. If it doesn't, open an issue.

This is my first public Linux project. Feedback welcome!

---

**Edit:** Wow, thanks for the gold/awards! For everyone asking about [common question], check the CHEATSHEET.md in the repo. It has quick commands for troubleshooting.

**Edit 2:** For those asking about Wispr Flow dictionary import — yes, there's an import tool that handles JSON/CSV/TXT formats. See IMPORT-GUIDE.md.
