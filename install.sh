#!/bin/bash
# Chronolapse Installation Script
# Automated installation for Linux/macOS systems

set -e

echo "======================================"
echo "Chronolapse Installation Script"
echo "======================================"
echo ""

# Check Python version
# Check Python version
PYTHON_CMD=""
if command -v python3 &> /dev/null; then
    PYTHON_VERSION=$(python3 --version 2>&1 | grep -oP '\d+\.\d+' | head -1)
    if [ -n "$PYTHON_VERSION" ]; then
        PYTHON_MAJOR=$(echo $PYTHON_VERSION | cut -d'.' -f1)
        PYTHON_MINOR=$(echo $PYTHON_VERSION | cut -d'.' -f2)
        
        if [ "$PYTHON_MAJOR" -gt 3 ] || ([ "$PYTHON_MAJOR" -eq 3 ] && [ "$PYTHON_MINOR" -ge 7 ]); then
            PYTHON_CMD="python3"
            echo "✓ Found Python $PYTHON_VERSION"
        fi
    fi
fi

if [ -z "$PYTHON_CMD" ]; then
    echo "✗ Error: Python 3.7 or higher is required"
    echo "  Please install Python 3.7+ and try again"
    exit 1
fi

# Check for pip
if ! command -v pip3 &> /dev/null; then
    echo "✗ Error: pip3 is not installed"
    echo "  Please install pip3 and try again"
    exit 1
fi
echo "✓ Found pip3"

# Detect OS
OS_TYPE=$(uname -s)
echo "✓ Detected OS: $OS_TYPE"

# Install system dependencies based on OS
echo ""
echo "Installing system dependencies..."
if [ "$OS_TYPE" = "Linux" ]; then
    if command -v apt-get &> /dev/null; then
        echo "Using apt-get package manager..."
        sudo apt-get update
        sudo apt-get install -y \
            libgtk-3-dev \
            libwebkit2gtk-4.0-dev \
            libjpeg-dev \
            libtiff-dev \
            libsdl2-dev \
            libgstreamer1.0-dev \
            libgstreamer-plugins-base1.0-dev \
            libnotify-dev \
            freeglut3-dev \
            libsm-dev \
            libgl1-mesa-glx \
            mencoder \
            mplayer
        echo "✓ System dependencies installed"
    elif command -v yum &> /dev/null; then
        echo "Using yum package manager..."
        sudo yum install -y \
            gtk3-devel \
            webkit2gtk3-devel \
            libjpeg-turbo-devel \
            libtiff-devel \
            SDL2-devel \
            gstreamer1-devel \
            gstreamer1-plugins-base-devel \
            libnotify-devel \
            freeglut-devel \
            libSM-devel \
            mesa-libGL \
            mencoder
        echo "✓ System dependencies installed"
    else
        echo "⚠ Warning: Unknown package manager. You may need to install dependencies manually."
    fi
elif [ "$OS_TYPE" = "Darwin" ]; then
    if command -v brew &> /dev/null; then
        echo "Using Homebrew package manager..."
        brew install gtk+3 ffmpeg
        echo "✓ System dependencies installed"
    else
        echo "⚠ Warning: Homebrew not found. Please install dependencies manually."
        echo "  Install Homebrew from: https://brew.sh"
    fi
else
    echo "⚠ Warning: Unsupported OS. You may need to install dependencies manually."
fi

# Create virtual environment
echo ""
echo "Creating virtual environment..."
if [ -d "venv" ]; then
    echo "⚠ Virtual environment already exists. Skipping creation."
else
    $PYTHON_CMD -m venv venv
    echo "✓ Virtual environment created"
fi

# Activate virtual environment
echo "Activating virtual environment..."
source venv/bin/activate

# Upgrade pip
echo "Upgrading pip..."
pip install --upgrade pip

# Install Python dependencies
echo ""
echo "Installing Python dependencies..."
pip install -r requirements.txt

echo ""
echo "======================================"
echo "✓ Installation Complete!"
echo "======================================"
echo ""
echo "To run Chronolapse:"
echo "  1. Activate the virtual environment:"
echo "     source venv/bin/activate"
echo "  2. Run the application:"
echo "     python chronolapse.py"
echo ""
echo "Or use the quick start script:"
echo "  ./run.sh"
echo ""
