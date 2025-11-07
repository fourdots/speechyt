# SpeechyT: The Fast, Free, Offline Speech-to-Text Solution Linux Users Have Been Waiting For

## Why I Built SpeechyT

As a Linux user and developer, I've always envied Mac users with their seamless speech-to-text apps like Wispr Flow. Sure, there are cloud-based solutions, but they require API keys, cost money, and send your voice data to external servers. I wanted something that just *works* — fast, private, and free.

After years of cobbling together scripts and trying commercial solutions that never quite fit Linux, I decided to build **SpeechyT** — and I'm sharing it with the community today.

## What Makes SpeechyT Special?

### ⚡ Lightning Fast
SpeechyT uses OpenAI's **faster-whisper** engine (not the standard Whisper), delivering transcriptions in **1-2 seconds**. That's 2-4x faster than the original Whisper implementation. When you're dictating code, emails, or documentation, those seconds matter.

### 🔒 100% Private & Offline
Everything runs locally on your machine. Your voice never leaves your computer. No API keys, no cloud services, no subscription fees. It's yours.

### 🎯 Smart Custom Dictionary
Technical terms giving you trouble? Add them once to your custom dictionary and they'll be capitalized correctly forever:
- `kubernetes → Kubernetes`
- `postgresql → PostgreSQL`
- `javascript → JavaScript`

The dictionary uses a two-layer correction system: it helps Whisper recognize terms during transcription, then applies post-processing replacements. You can even import dictionaries from other apps (like Wispr Flow on Mac).

### 📜 Transcription History
Never lose a transcription again. SpeechyT automatically saves your last 20 transcriptions with timestamps. If something doesn't paste correctly, just run:
```bash
~/speechyt/view-history.sh --copy 1
```
Boom — it's back in your clipboard.

### 🖱️ Dead Simple Interface
Double-tap your mouse side button (or backtick key). Speak. Double-tap again. Text appears. That's it.

## Installation (5 Minutes)

```bash
# Install dependencies
sudo apt install ffmpeg xclip xdotool xbindkeys python3-pip python3-venv git bc

# Clone and install
cd ~
git clone https://github.com/fourdots/speechyt.git
cd speechyt
./install.sh
```

The installer creates a Python virtual environment, downloads the AI model (~74MB), and sets up your mouse button trigger. Logout and login (or run `xbindkeys`), and you're done.

## Real-World Performance

I've been using SpeechyT daily for the past week, and here's what I've noticed:

**Speed:** Transcription takes 1-2 seconds for typical sentences. That's faster than I can type them.

**Accuracy:** With the custom dictionary tuned to my technical terms (Docker, Kubernetes, FastAPI, etc.), accuracy is 95%+. Punctuation is automatic and surprisingly good.

**Reliability:** It just works. No authentication errors, no rate limits, no "premium feature" paywalls.

## The Technical Stack

Under the hood, SpeechyT uses:
- **faster-whisper** (optimized C++ implementation of OpenAI Whisper)
- **base.en model** (balanced speed/accuracy, English-only)
- **ffmpeg** for audio capture
- **xbindkeys** for global hotkeys
- Pure Bash scripts (no heavyweight frameworks)

The entire codebase is ~500 lines of readable Bash. No magic, no complexity.

## Comparison: SpeechyT vs. Commercial Options

| Feature | SpeechyT | Commercial Apps |
|---------|----------|-----------------|
| Cost | Free | $5-20/month |
| Speed | 1-2 seconds | 1-3 seconds |
| Privacy | 100% local | Cloud-based |
| Offline | Yes | Usually no |
| Custom dictionary | Yes | Sometimes |
| Linux support | Native | Limited/None |
| History | Last 20 | Varies |
| Setup time | 5 minutes | 5-30 minutes |

## Who Should Use SpeechyT?

- **Developers** who need to dictate code comments or documentation
- **Writers** who prefer speaking over typing
- **Privacy-conscious users** who don't want voice data in the cloud
- **Linux enthusiasts** tired of "Mac/Windows only" solutions
- **Anyone** who wants fast, accurate dictation without recurring costs

## Limitations (Let's Be Honest)

SpeechyT isn't perfect:
- **English only** (by design — the base.en model is optimized for English)
- **Requires decent CPU** (transcription uses ~30-50% CPU during processing)
- **Not real-time** (you record, then it transcribes — not streaming)
- **Linux only** (that's the point!)

## The Roadmap

I'm actively developing SpeechyT and have some exciting features planned:
- GPU acceleration support (for even faster transcription)
- Multiple language support
- Voice commands integration
- Real-time streaming mode
- Better model selection UI

But honestly? The current version does 95% of what I need, and I suspect it'll do the same for you.

## Try It Today

SpeechyT is open source (MIT license) and available on GitHub:
🔗 **https://github.com/fourdots/speechyt**

Clone it, try it for 5 minutes, and let me know what you think. If you run into issues, there's a comprehensive troubleshooting guide in the repo.

## Final Thoughts

Linux has always been the underdog for desktop productivity apps. We have amazing developer tools, but consumer-facing applications often lag behind Mac and Windows. SpeechyT is my small contribution to changing that.

If you're tired of typing or just want to try something new, give SpeechyT a shot. It's free, it's fast, and it respects your privacy.

And if you find it useful, star the repo and spread the word. Let's show the world that Linux can have nice things too.

---

**About the Author:** I'm a Linux developer and open-source enthusiast who believes powerful tools should be accessible to everyone. SpeechyT is my first public project, and I'm excited to share it with the community.

**GitHub:** https://github.com/fourdots/speechyt
**Issues/Feedback:** https://github.com/fourdots/speechyt/issues

---

*This article is based on SpeechyT v1.0. Check the GitHub repo for the latest features and updates.*
