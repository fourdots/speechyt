# 🎯 SpeechyT Advanced Customization Guide

## Table of Contents
1. [Initial Prompt - Context & Vocabulary](#initial-prompt)
2. [Post-Processing - Text Cleanup](#post-processing)
3. [Whisper Parameters - Fine-Tuning](#whisper-parameters)
4. [Performance Optimization](#performance-optimization)
5. [Advanced Features](#advanced-features)
6. [Example Configurations](#example-configurations)

---

## 1. Initial Prompt - Context & Vocabulary {#initial-prompt}

The `--initial_prompt` parameter is incredibly powerful for improving accuracy without sacrificing speed.

### Basic Usage
Edit `/home/sho/s2t/toggle_recording.sh` line 26:
```bash
whisper $HOME/s2t/tmp/recording.wav --model tiny --language en \
  --initial_prompt "Your context here" \
  --output_dir="${HOME}/s2t/tmp/" --output_format="txt" 2>/dev/null
```

### What You Can Include

#### Custom Vocabulary
```bash
--initial_prompt "Common terms: WinSURF, CURSOR, Laravel, Vue.js, npm, GitHub, API, MySQL, Redis, Ubuntu, Linux, macOS"
```

#### Context Setting
```bash
--initial_prompt "This is a technical discussion about software development, coding, and project management. Topics include web development, databases, APIs, and DevOps."
```

#### Style Preferences
```bash
--initial_prompt "Format: Use proper capitalization. Include punctuation. Technical terms should be properly cased (GitHub not github, MySQL not mysql)."
```

#### Company/Project Specific
```bash
--initial_prompt "Project: Fantom automation system. Company: FourDots. Technologies: Laravel, PHP, Vue.js, Docker, Supervisor. Team members: Sho, Rad."
```

### Advanced Initial Prompt Template
```bash
INITIAL_PROMPT="Context: Software development and coding.
Vocabulary: API, REST, GraphQL, Docker, Kubernetes, CI/CD, Git, npm, yarn, pnpm, TypeScript, JavaScript, Python, PHP, Laravel, React, Vue, Node.js, MySQL, PostgreSQL, Redis, MongoDB.
Names: Sho, Rad, FourDots, Fantom, SpeechyT, WinSURF, CURSOR.
Style: Technical writing with proper capitalization and punctuation.
Format: Complete sentences. Preserve technical terms exactly."

# Use in whisper command:
--initial_prompt "$INITIAL_PROMPT"
```

---

## 2. Post-Processing - Text Cleanup {#post-processing}

Add these after transcription in `toggle_recording.sh` (after line 30):

### Remove Unwanted Line Breaks
```bash
# Keep paragraph breaks but join broken sentences
sed -i ':a;N;$!ba;s/\n\([a-z]\)/ \1/g' $TRANSCRIPTION_FILE
```

### Fix Common Issues
```bash
# Fix spacing around punctuation
sed -i 's/\s*\([.,;:!?]\)/\1/g' $TRANSCRIPTION_FILE

# Ensure space after punctuation
sed -i 's/\([.,;:!?]\)\([A-Za-z]\)/\1 \2/g' $TRANSCRIPTION_FILE

# Capitalize first letter of sentences
sed -i 's/\([.!?]\s*\)\([a-z]\)/\1\u\2/g' $TRANSCRIPTION_FILE
```

### Custom Replacements Dictionary
Create a file `/home/sho/s2t/replacements.txt`:
```
github->GitHub
mysql->MySQL
api->API
javascript->JavaScript
typescript->TypeScript
nodejs->Node.js
```

Then apply:
```bash
while IFS='->' read -r old new; do
    sed -i "s/\b$old\b/$new/gi" $TRANSCRIPTION_FILE
done < /home/sho/s2t/replacements.txt
```

---

## 3. Whisper Parameters - Fine-Tuning {#whisper-parameters}

### Core Parameters

| Parameter | Default | Description | Impact |
|-----------|---------|-------------|---------|
| `--temperature` | 0.0 | Sampling temperature (0-1) | Lower = more consistent |
| `--best_of` | 5 | Number of candidates for temperature sampling | Higher = better quality, slower |
| `--beam_size` | 5 | Beam search width | Higher = better, much slower |
| `--patience` | 1.0 | Patience for beam search | Higher = better, slower |
| `--length_penalty` | 1.0 | Exponential penalty for length | Adjust for shorter/longer outputs |

### Voice Detection

| Parameter | Default | Description | When to Adjust |
|-----------|---------|-------------|----------------|
| `--no_speech_threshold` | 0.6 | Threshold for detecting silence | Lower if missing speech |
| `--logprob_threshold` | -1.0 | Log probability threshold | Lower for more aggressive filtering |
| `--compression_ratio_threshold` | 2.4 | Filter out anomalous results | Higher if getting gibberish |

### Output Control

| Parameter | Description | Example |
|-----------|-------------|---------|
| `--suppress_tokens` | Token IDs to suppress | `--suppress_tokens "13,14,15"` |
| `--suppress_blank` | Suppress blank outputs | Add flag to prevent empty results |
| `--condition_on_previous_text` | Use context from previous segments | Improves continuity |
| `--word_timestamps` | Generate word-level timestamps | Useful for sync applications |

---

## 4. Performance Optimization {#performance-optimization}

### Speed vs Quality Trade-offs

#### Maximum Speed (Current)
```bash
--model tiny --beam_size 1 --best_of 1
```

#### Balanced (Tiny model with better accuracy)
```bash
--model tiny --beam_size 3 --best_of 3 --temperature 0
```

#### Quality Focus (Still fast)
```bash
--model base --beam_size 5 --temperature 0 --condition_on_previous_text True
```

### CPU Optimization
```bash
# Use all CPU cores
--threads 0

# Specific core count
--threads 8
```

### Memory Usage
```bash
# Reduce memory for long recordings
--chunk_length 30  # Process in 30-second chunks
```

---

## 5. Advanced Features {#advanced-features}

### Multiple Output Formats
```bash
# Get both text and subtitles
--output_format "txt,srt,vtt"
```

### Timestamp Information
```bash
# Include timestamps in output
--word_timestamps True --output_format "json"
```

### Language Detection (Multi-language)
```bash
# Auto-detect language (slower)
whisper recording.wav --model tiny --task transcribe
```

### Translation to English
```bash
# Translate foreign speech to English
--task translate --language auto
```

### VAD (Voice Activity Detection)
```bash
# Use VAD to filter silence (requires additional setup)
--vad_filter True --vad_parameters '{"threshold": 0.5}'
```

---

## 6. Example Configurations {#example-configurations}

### For Coding/Development Work
```bash
#!/bin/bash
# In toggle_recording.sh, replace the whisper command with:

INITIAL_PROMPT="Context: Software development discussion.
Tech stack: Linux, Python, JavaScript, TypeScript, PHP, Laravel, React, Vue, Docker, Git.
Commands: npm, yarn, git, docker, sudo, chmod, curl, wget.
Style: Technical documentation style with proper formatting."

whisper $HOME/s2t/tmp/recording.wav \
  --model tiny \
  --language en \
  --initial_prompt "$INITIAL_PROMPT" \
  --temperature 0 \
  --no_speech_threshold 0.5 \
  --compression_ratio_threshold 2.4 \
  --output_dir="${HOME}/s2t/tmp/" \
  --output_format="txt" 2>/dev/null

# Post-process
TRANSCRIPTION_FILE="$HOME/s2t/tmp/recording.txt"

# Fix line breaks
sed -i ':a;N;$!ba;s/\n\([a-z]\)/ \1/g' $TRANSCRIPTION_FILE

# Apply custom replacements
sed -i 's/\bgithub\b/GitHub/gi' $TRANSCRIPTION_FILE
sed -i 's/\bapi\b/API/gi' $TRANSCRIPTION_FILE
sed -i 's/\bnpm\b/npm/gi' $TRANSCRIPTION_FILE
```

### For General Dictation
```bash
INITIAL_PROMPT="Format: Professional writing with proper grammar and punctuation.
Style: Clear and concise sentences."

whisper $HOME/s2t/tmp/recording.wav \
  --model tiny \
  --language en \
  --initial_prompt "$INITIAL_PROMPT" \
  --temperature 0.2 \
  --best_of 3 \
  --output_dir="${HOME}/s2t/tmp/" \
  --output_format="txt" 2>/dev/null
```

### For Meeting Notes
```bash
INITIAL_PROMPT="Context: Business meeting notes.
Participants: [Add names here].
Topics: Project updates, deadlines, action items.
Format: Bullet points and clear structure."

whisper $HOME/s2t/tmp/recording.wav \
  --model base \
  --language en \
  --initial_prompt "$INITIAL_PROMPT" \
  --condition_on_previous_text True \
  --output_dir="${HOME}/s2t/tmp/" \
  --output_format="txt" 2>/dev/null
```

---

## 🚀 Quick Start Recommendations

### Step 1: Start with Initial Prompt
Add your common vocabulary and context to improve accuracy immediately without speed impact.

### Step 2: Add Basic Post-Processing
Fix line breaks and capitalization issues with simple sed commands.

### Step 3: Create Custom Dictionary
Build your replacements.txt file with terms specific to your work.

### Step 4: Fine-Tune Parameters
Experiment with temperature and thresholds based on your environment.

### Step 5: Test and Iterate
Record sample phrases and adjust settings based on results.

---

## 📊 Performance Impact Guide

| Feature | Speed Impact | Quality Impact |
|---------|--------------|----------------|
| Initial Prompt | None | High |
| Post-Processing | Minimal | High |
| Temperature 0 | None | Medium |
| Beam Size +1 | ~10% slower | Medium |
| Best Of +1 | ~5% slower | Low-Medium |
| Model Size Up | ~2-3x slower | High |

---

## 💡 Pro Tips

1. **Initial Prompt is Free**: No speed penalty, massive accuracy boost
2. **Post-Process Smartly**: Simple regex is fast, complex parsing is slow
3. **Test Incrementally**: Change one parameter at a time
4. **Profile Your Speech**: Adjust thresholds based on your voice/accent
5. **Context Matters**: Different prompts for different tasks
6. **Keep Backups**: Save your working config before experimenting

---

## 📝 Notes

- All paths assume installation at `/home/sho/s2t/`
- Whisper updates may add new parameters - check with `whisper --help`
- GPU acceleration (if available) dramatically improves all models
- The tiny model with good configuration can match base model accuracy

---

**Remember**: The tiny model at ~1-2 seconds gives you plenty of headroom for customization while maintaining excellent responsiveness!
