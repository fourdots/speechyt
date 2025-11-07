#!/bin/bash

# SpeechyT Installation Script
# This script sets up the complete speech-to-text system on Linux

set -e  # Exit on error

echo "🎤 SpeechyT Installer - Linux Speech-to-Text System"
echo "===================================================="
echo ""

# Check if running on Linux
if [[ "$OSTYPE" != "linux-gnu"* ]]; then
    echo "❌ This installer only works on Linux systems"
    exit 1
fi

# Get the script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
HOME_DIR="$HOME"

echo "📦 Installing system dependencies..."
sudo apt update
sudo apt install -y ffmpeg xclip xdotool xbindkeys python3-pip python3-venv git bc

echo ""
echo "🐍 Setting up Python virtual environment..."
if [ ! -d "$HOME_DIR/env_sandbox" ]; then
    python3 -m venv "$HOME_DIR/env_sandbox"
    echo "✅ Virtual environment created at ~/env_sandbox"
else
    echo "ℹ️  Virtual environment already exists at ~/env_sandbox"
fi

echo ""
echo "📚 Installing OpenAI Whisper..."
source "$HOME_DIR/env_sandbox/bin/activate"
pip install --upgrade pip
pip install openai-whisper
deactivate
echo "✅ Whisper installed successfully"

echo ""
echo "⬇️  Downloading Whisper base model (fastest)..."
source "$HOME_DIR/env_sandbox/bin/activate"
python -c "import whisper; whisper.load_model('base'); print('✅ Base model downloaded')"
deactivate

echo ""
echo "🔧 Configuring xbindkeys..."
# Backup existing config if it exists
if [ -f "$HOME_DIR/.xbindkeysrc" ]; then
    cp "$HOME_DIR/.xbindkeysrc" "$HOME_DIR/.xbindkeysrc.backup"
    echo "ℹ️  Backed up existing .xbindkeysrc to .xbindkeysrc.backup"
fi

# Create xbindkeys config
cat > "$HOME_DIR/.xbindkeysrc" << 'EOF'
# Speech-to-text keybindings
# Backtick key (`) - double-tap to start, double-tap to stop
"$HOME/Documents/dev-projects/speechyt/double_tap_handler.sh"
    m:0x0 + c:49
    grave

# Mouse button 4 (side button) - double-tap to start, double-tap to stop
"$HOME/Documents/dev-projects/speechyt/double_tap_handler.sh"
    m:0x0 + b:8
    button8
EOF

# Replace $HOME with actual path
sed -i "s|\$HOME|$HOME_DIR|g" "$HOME_DIR/.xbindkeysrc"
echo "✅ xbindkeys configured"

echo ""
echo "🚀 Setting up auto-start..."
mkdir -p "$HOME_DIR/.config/autostart"
cat > "$HOME_DIR/.config/autostart/xbindkeys.desktop" << 'EOF'
[Desktop Entry]
Type=Application
Name=xbindkeys
Comment=Start xbindkeys for speech-to-text hotkeys
Exec=xbindkeys
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
X-GNOME-Autostart-Delay=2
EOF
echo "✅ Auto-start configured"

echo ""
echo "⚙️  Configuring key repeat settings..."
if ! grep -q "xset -r 49" "$HOME_DIR/.profile"; then
    echo "" >> "$HOME_DIR/.profile"
    echo "# Disable key repeat for backtick key (for speech-to-text toggle)" >> "$HOME_DIR/.profile"
    echo "xset -r 49  # Prevents multiple triggers when pressing backtick" >> "$HOME_DIR/.profile"
    echo "✅ Key repeat disabled for backtick"
else
    echo "ℹ️  Key repeat already configured"
fi

# Apply immediately
xset -r 49 2>/dev/null || true

echo ""
echo "🔗 Creating symlinks for easy access..."
# Create symlinks in home directory for convenience
ln -sf "$SCRIPT_DIR" "$HOME_DIR/speechyt"
echo "✅ Created symlink at ~/speechyt"

echo ""
echo "🎉 Installation complete!"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "To start using SpeechyT:"
echo ""
echo "1. Run: xbindkeys"
echo "   (or logout/login for auto-start)"
echo ""
echo "2. Double-tap backtick (`) or mouse button 4 to start recording"
echo "3. Speak clearly in English"
echo "4. Double-tap again to stop and transcribe"
echo ""
echo "Test it now in any text field!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "For configuration options, see: ~/speechyt/README.md"
echo ""
