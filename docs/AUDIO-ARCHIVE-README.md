# Audio Archive for Model Training

## Overview

SpeechyT automatically archives every recording with its transcription, creating paired datasets perfect for training custom voice models.

## Archive Structure

```
audio_archive/
├── 20241108_012345.wav  ← Audio recording
├── 20241108_012345.txt  ← Paired transcription
├── 20241108_012456.wav
├── 20241108_012456.txt
└── ...
```

Each recording is saved with a timestamp format: `YYYYMMDD_HHMMSS`

## File Pairing

- **Audio file** (`.wav`): Your voice recording at 44.1kHz, stereo
- **Text file** (`.txt`): Transcription with dictionary corrections applied

Both files share the **same timestamp**, making it easy to pair them programmatically:
```bash
# Example: Load paired data
for wav in audio_archive/*.wav; do
    txt="${wav%.wav}.txt"
    # Process $wav and $txt together
done
```

## Management Commands

### View all recordings
```bash
./manage-audio-archive.sh list
```
Shows each recording with audio size and transcription preview.

### Check statistics
```bash
./manage-audio-archive.sh count
```
Displays:
- Total audio files
- Total transcriptions
- Number of paired recordings
- Total disk space used

### Export for training
```bash
./manage-audio-archive.sh export
```
Copies all paired files to `~/Desktop/speechyt_audio/` for easy transfer.

### Clean old recordings
```bash
./manage-audio-archive.sh old 30  # Delete recordings older than 30 days
```

### Delete everything
```bash
./manage-audio-archive.sh clean  # WARNING: Deletes all archived data
```

## Training Use Cases

### Voice Cloning
- Use paired audio/text for TTS model fine-tuning
- Minimum recommended: 30-60 minutes of paired data

### ASR Fine-tuning
- Improve Whisper accuracy for your voice
- Include technical terms from your dictionary

### Custom Wake Word
- Extract specific phrases from transcriptions
- Train wake word detection models

## Privacy

- Archive is stored locally at `~/Documents/dev-projects/speechyt/audio_archive/`
- `.gitignore` excludes this directory from git
- Your voice data never leaves your machine

## Notes

- **No automatic deletion**: Files are kept indefinitely (unlike history/ which keeps only last 20)
- **Disk space**: Approximately 1-2 MB per minute of recording
- **Quality**: 44.1kHz stereo WAV format, suitable for production use
- **Transcriptions**: Already cleaned with your custom dictionary corrections
