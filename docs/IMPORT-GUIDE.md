# 📥 Import Dictionary from Wispr Flow (Mac)

## Step-by-Step Guide

### On Mac (Wispr Flow):

1. **Export your dictionary:**
   - Open Wispr Flow settings
   - Look for "Dictionary" or "Custom Words"
   - Click "Export" or "Export Dictionary"
   - Save as JSON, CSV, or TXT file
   - Transfer file to Linux (USB, cloud, email, etc.)

### On Linux (SpeechyT):

2. **Import the dictionary:**

```bash
# Make import script executable
chmod +x ~/speechyt/import-dictionary.sh

# Import your Wispr Flow dictionary
~/speechyt/import-dictionary.sh ~/Downloads/wispr-flow-dictionary.json
```

---

## Supported Formats

### 1. **JSON** (Wispr Flow default)
```json
{
  "kubernetes": "Kubernetes",
  "postgresql": "PostgreSQL",
  "dont": "don't"
}
```

### 2. **CSV**
```csv
wrong,correct
kubernetes,Kubernetes
postgresql,PostgreSQL
dont,don't
```

### 3. **Text with arrows**
```
kubernetes → Kubernetes
postgresql → PostgreSQL
dont → don't
```

### 4. **Plain text** (auto-capitalizes)
```
kubernetes
postgresql
javascript
```

---

## Quick Import Examples

```bash
# Import JSON (Wispr Flow export)
./import-dictionary.sh ~/Downloads/wispr-dictionary.json

# Import CSV
./import-dictionary.sh ~/Downloads/my-terms.csv

# Import plain text
./import-dictionary.sh ~/Downloads/tech-terms.txt
```

---

## After Import

**Your existing SpeechyT dictionary is automatically backed up to:**
```
~/speechyt/dictionary.backup.txt
```

**Test it:**
1. Double-tap mouse button 4
2. Say a word from your imported dictionary
3. Should be auto-corrected!

---

## Manual Transfer (Without Export Feature)

If Wispr Flow doesn't have export, you can manually copy terms:

1. **Create a simple text file on Mac:**
```
kubernetes
postgresql
reactjs
typescript
mycompanyname
```

2. **Transfer to Linux and import:**
```bash
./import-dictionary.sh ~/Downloads/my-terms.txt
```

---

## Troubleshooting

**Q: Import didn't work?**
- Check file exists: `ls ~/Downloads/your-file.json`
- Check format: `cat ~/Downloads/your-file.json`
- Check dictionary: `cat ~/speechyt/dictionary.txt`

**Q: How to restore backup?**
```bash
cp ~/speechyt/dictionary.backup.txt ~/speechyt/dictionary.txt
```

**Q: How to merge multiple dictionaries?**
```bash
# Import multiple files
./import-dictionary.sh ~/Downloads/dict1.json
./import-dictionary.sh ~/Downloads/dict2.csv
./import-dictionary.sh ~/Downloads/dict3.txt
```

---

**Enjoy seamless dictionary sync between Mac and Linux!** 🎉
