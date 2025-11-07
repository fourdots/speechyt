# SpeechyT GPU Acceleration Setup

## Quick Installation for RTX 2060

### Step 1: Install NVIDIA Drivers (5 min + reboot)
```bash
sudo ubuntu-drivers install nvidia-driver-580-open
sudo reboot
```

### Step 2: Verify Driver Installation (after reboot)
```bash
nvidia-smi
```
Should show your RTX 2060 with CUDA Version.

### Step 3: Install CUDA Toolkit (3-5 min)
```bash
sudo apt update
sudo apt install -y nvidia-cuda-toolkit python3-dev
```

### Step 4: Upgrade faster-whisper with GPU Support (2-3 min)
```bash
source ~/env_sandbox/bin/activate
pip install --upgrade pip
pip install nvidia-cudnn-cu12
pip install --upgrade faster-whisper
deactivate
```

### Step 5: Test GPU Acceleration
```bash
# Record something with SpeechyT
# Should now be 0.5-1 second instead of 3-5 seconds!
```

## Expected Performance:

| Usage | CPU Time | GPU Time | Saved |
|-------|----------|----------|-------|
| 1 recording | 4s | 0.5s | 3.5s |
| 100/day | 6-7 min | 1 min | 5-6 min/day |
| Per year | 36 hours | 6 hours | **30 hours!** |

## Troubleshooting:

### Check if GPU is being used:
```bash
# In another terminal while recording:
watch -n 0.5 nvidia-smi
```
Should show GPU usage spike during transcription.

### If still using CPU:
Check faster-whisper installation:
```bash
source ~/env_sandbox/bin/activate
python -c "import torch; print(torch.cuda.is_available())"
# Should print: True
deactivate
```

## Disk Space Required:
- NVIDIA drivers: ~500MB
- CUDA toolkit: ~3.5GB
- Python packages: ~1GB
- **Total: ~5GB**

## GPU Memory Usage:
- Idle: 0MB
- During transcription: ~500-800MB (1-2 seconds)
- Won't affect gaming or other GPU tasks
