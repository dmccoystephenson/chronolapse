# Chronolapse Quick Start Guide

This is a condensed quick-start guide. For complete installation instructions, see [INSTALL.md](INSTALL.md).

## Prerequisites

- Python 3.7+
- pip
- (Optional) Docker

## Installation

### Option 1: Automated Installation (Recommended)

**Linux/macOS:**
```bash
chmod +x install.sh
./install.sh
```

**Windows:**
```cmd
install.bat
```

### Option 2: Docker

```bash
# Allow X11 access (Linux)
xhost +local:docker

# Run with Docker Compose
docker compose up -d
```

### Option 3: Manual Installation

```bash
# Create virtual environment
python3 -m venv venv

# Activate (Linux/macOS)
source venv/bin/activate

# Activate (Windows)
venv\Scripts\activate.bat

# Install dependencies
pip install -r requirements.txt
```

## Running Chronolapse

### With Installation Scripts

**Linux/macOS:**
```bash
./run.sh
```

**Windows:**
```cmd
run.bat
```

### With Docker

```bash
docker compose up
```

### Manual

```bash
# Activate virtual environment first
source venv/bin/activate  # Linux/macOS
# or
venv\Scripts\activate.bat  # Windows

# Run application
python chronolapse.py
```

## Command Line Options

```bash
# Start with auto-capture enabled
python chronolapse.py -a

# Start in background
python chronolapse.py -b

# Custom config file
python chronolapse.py --config_file my_config.json

# Verbose output
python chronolapse.py -v

# Debug output
python chronolapse.py -d
```

## Common Tasks

### Configure Webcam

1. Run Chronolapse
2. Check "Use Webcam"
3. Click "Configure Webcam"
4. Test webcam capture
5. Set save folder and preferences

### Configure Screenshots

1. Run Chronolapse
2. Check "Use Screenshot"
3. Click "Configure Screenshot"
4. Set save folder and preferences
5. (Optional) Enable dual monitor or subsection capture

### Create Video from Images

1. Switch to "Video" tab
2. Select source folder containing images
3. Select output folder for video
4. Set framerate (default: 10 fps)
5. Choose codec (mpeg4 recommended)
6. Click "Create Video"

**Note:** Requires MEncoder/MPlayer installed

### Picture-in-Picture

1. Switch to "PIP" tab
2. Select main image folder
3. Select PIP image folder
4. Select output folder
5. Choose size and position
6. Click "Create PIP"

## Troubleshooting Quick Fixes

### Issue: "No module named 'wx'"
```bash
pip install wxPython
```

### Issue: "No module named 'cv2'"
```bash
pip install opencv-python
```

### Issue: Webcam not found
- Check webcam is connected
- Try different device number in config
- On Linux: check `/dev/video0` permissions

### Issue: MEncoder not found

**Linux:**
```bash
sudo apt-get install mencoder mplayer
```

**macOS:**
```bash
brew install ffmpeg
```

**Windows:**
Download from [SourceForge](https://sourceforge.net/projects/mplayer-win32/)

### Issue: Docker GUI not displaying

```bash
xhost +local:docker
export DISPLAY=:0
```

## Next Steps

- Read [INSTALL.md](INSTALL.md) for detailed installation options
- Read [README.md](README.md) for complete feature documentation
- Check configuration options in `chronolapse.config`

## Getting Help

- [GitHub Issues](https://github.com/dmccoystephenson/chronolapse/issues)
- Run with debug flag: `python chronolapse.py -d`
