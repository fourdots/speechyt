# 📚 SpeechyT Dictionary Feature

## Two-Layer Correction System

### Layer 1: **Initial Prompt** (Helps Whisper Recognize Terms)
Located in `toggle_recording.sh` line 28:
```bash
INITIAL_PROMPT="Technical terms: SpeechyT, Fantom, OctoBrowser..."
```

**How to customize:**
1. Edit `toggle_recording.sh`
2. Find line 28 with `INITIAL_PROMPT=`
3. Add your technical terms, names, or specialized vocabulary
4. Separate with commas

**Example:**
```bash
INITIAL_PROMPT="Technical terms: SpeechyT, John Smith, Kubernetes, PostgreSQL, React.js"
```

---

### Layer 2: **Post-Processing Dictionary** (Word Replacements)
Located in `dictionary.txt`:

**Format:**
```
wrong_word → Correct_Word
```

**Examples:**
```
speechyt → SpeechyT
fantom → Fantom
dont → don't
i'm → I'm
kubernetes → Kubernetes
```

**How to add your words:**
1. Open `~/speechyt/dictionary.txt`
2. Add one replacement per line
3. Use format: `incorrect → correct`
4. Case-insensitive matching
5. Comments start with `#`

---

## Quick Start

### Add a New Technical Term:

**Step 1:** Add to initial prompt (helps recognition)
```bash
# Edit toggle_recording.sh line 28
INITIAL_PROMPT="Technical terms: SpeechyT, Fantom, YourCompanyName"
```

**Step 2:** Add to dictionary (fixes any mistakes)
```bash
# Add to dictionary.txt
yourcompanyname → YourCompanyName
your company → YourCompanyName
```

---

## Common Use Cases

### 1. **Company/Product Names**
```
google → Google
microsoft → Microsoft
openai → OpenAI
chatgpt → ChatGPT
```

### 2. **Technical Terms**
```
javascript → JavaScript
typescript → TypeScript
postgresql → PostgreSQL
mysql → MySQL
```

### 3. **Names (People/Places)**
```
john smith → John Smith
new york → New York
san francisco → San Francisco
```

### 4. **Abbreviations/Acronyms**
```
ai → AI
api → API
ui → UI
ux → UX
seo → SEO
```

### 5. **Common Contractions**
```
dont → don't
wont → won't
cant → can't
im → I'm
```

---

## Testing Your Dictionary

1. Record: "I'm using speechyt with fantom and octobrowser"
2. Result: "I'm using SpeechyT with Fantom and OctoBrowser"

---

## Tips

✅ **DO:**
- Add technical terms to BOTH initial prompt AND dictionary
- Use exact capitalization you want in the dictionary
- Test after adding new terms

❌ **DON'T:**
- Use regex or special characters in dictionary
- Add too many terms to initial prompt (max 20-30 words)
- Forget to save files after editing!

---

## Quick Edit Commands

```bash
# Edit initial prompt
nano ~/speechyt/toggle_recording.sh
# (Find line 28)

# Edit dictionary
nano ~/speechyt/dictionary.txt
```

---

**Enjoy more accurate transcriptions!** 🎯
