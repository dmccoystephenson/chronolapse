# Chronolapse Installation Guide

This guide covers multiple installation methods for Chronolapse, including automated installation scripts and Docker containerization.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Quick Start (Recommended)](#quick-start-recommended)
- [Docker Installation](#docker-installation)
- [Manual Installation](#manual-installation)
- [Windows Installation](#windows-installation)
- [Linux Installation](#linux-installation)
- [macOS Installation](#macos-installation)
- [Building Executable](#building-executable)
- [Troubleshooting](#troubleshooting)

## Prerequisites

### All Platforms
- Python 3.7 or higher
- pip (Python package manager)
- Git (for cloning the repository)

### Linux
- GTK+ 3
- X11 for GUI display
- MEncoder/MPlayer for video rendering

### Windows
- Microsoft Visual C++ Redistributable
- MEncoder for video rendering ([Download here](https://sourceforge.net/projects/mplayer-win32/))

### macOS
- Xcode Command Line Tools
- Homebrew (recommended)

## Quick Start (Recommended)

### Linux/macOS

1. Clone the repository:
```bash
git clone https://github.com/dmccoystephenson/chronolapse.git
cd chronolapse
```

2. Run the installation script:
```bash
chmod +x install.sh
./install.sh
```

3. Run Chronolapse:
```bash
./run.sh
```

### Windows

1. Clone the repository:
```cmd
git clone https://github.com/dmccoystephenson/chronolapse.git
cd chronolapse
```

2. Run the installation script:
```cmd
install.bat
```

3. Run Chronolapse:
```cmd
run.bat
```

## Docker Installation

Docker provides a consistent, isolated environment and is the recommended approach for production deployments.

### Prerequisites
- Docker (version 20.10+)
- Docker Compose (version 1.29+)
- X11 server for GUI display

### Linux with X11

1. Allow Docker to connect to X11:
```bash
xhost +local:docker
```

2. Build and run with Docker Compose:
```bash
docker-compose up -d
```

3. View logs:
```bash
docker-compose logs -f
```

4. Stop the container:
```bash
docker-compose down
```

### Building Docker Image Manually

```bash
docker build -t chronolapse:latest .
```

### Running Docker Container Manually

```bash
docker run -it \
  -e DISPLAY=$DISPLAY \
  -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
  -v $(pwd)/screenshots:/app/screenshots \
  -v $(pwd)/webcam:/app/webcam \
  --device /dev/video0:/dev/video0 \
  chronolapse:latest
```

## Manual Installation

### 1. Create Virtual Environment

```bash
python3 -m venv venv
```

### 2. Activate Virtual Environment

**Linux/macOS:**
```bash
source venv/bin/activate
```

**Windows:**
```cmd
venv\Scripts\activate.bat
```

### 3. Install Dependencies

```bash
pip install -r requirements.txt
```

### 4. Install Platform-Specific Dependencies

**Windows:**
```bash
pip install pywin32 pefile
```

### 5. Run Chronolapse

```bash
python chronolapse.py
```

## Windows Installation

### Option 1: Using Installation Script (Recommended)

1. Open Command Prompt or PowerShell
2. Navigate to the chronolapse directory
3. Run `install.bat`
4. Run `run.bat` to start Chronolapse

### Option 2: Manual Installation

1. Install Python 3.7+ from [python.org](https://www.python.org/downloads/)
2. Install dependencies:
```cmd
pip install -r requirements.txt
pip install -r requirements-windows.txt
```

Or install packages individually:
```cmd
pip install wxPython>=4.0.0
pip install opencv-python>=4.0.0
pip install numpy>=1.19.0
pip install Pillow>=8.0.0
pip install pywin32>=300
pip install pefile>=2021.5.24
```

3. Download and install MEncoder from [SourceForge](https://sourceforge.net/projects/mplayer-win32/)
4. Add MEncoder to your PATH or configure it in Chronolapse settings

### Windows-Specific Notes

- **pywin32**: Required for idle time detection feature
- **pefile**: Required for building executables with PyInstaller
- **MEncoder**: Essential for video rendering capabilities

## Linux Installation

### Ubuntu/Debian

```bash
# Install system dependencies
sudo apt-get update
sudo apt-get install -y \
  python3 python3-pip python3-venv \
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

# Run installation script
chmod +x install.sh
./install.sh
```

### Fedora/CentOS/RHEL

```bash
# Install system dependencies
sudo yum install -y \
  python3 python3-pip \
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

# Run installation script
chmod +x install.sh
./install.sh
```

## macOS Installation

### Using Homebrew (Recommended)

```bash
# Install Homebrew if not already installed
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install dependencies
brew install python@3.9 gtk+3 ffmpeg

# Run installation script
chmod +x install.sh
./install.sh
```

### Manual Installation

```bash
# Install Python dependencies
pip3 install wxPython opencv-python numpy Pillow

# Install ffmpeg for video rendering
brew install ffmpeg
```

## Building Executable

To create a standalone executable using PyInstaller:

### Prerequisites

```bash
pip install pyinstaller>=4.0
```

### Windows

```cmd
pyinstaller chronolapse.py ^
  --icon=chronolapse.ico ^
  --onefile ^
  --noconsole ^
  --name=Chronolapse
```

### Linux/macOS

```bash
pyinstaller chronolapse.py \
  --icon=chronolapse.ico \
  --onefile \
  --noconsole \
  --name=Chronolapse
```

The executable will be created in the `dist/` directory.

### Advanced PyInstaller Options

For more control over the build process:

```bash
# Include additional data files
pyinstaller chronolapse.py \
  --icon=chronolapse.ico \
  --onefile \
  --noconsole \
  --add-data="chronolapse_24.ico:." \
  --add-data="chronolapsegui.wxg:." \
  --hidden-import=wx \
  --hidden-import=cv2 \
  --name=Chronolapse
```

## Troubleshooting

### Common Issues

#### "ModuleNotFoundError: No module named 'wx'"

**Solution:** Install wxPython:
```bash
pip install wxPython
```

#### "ModuleNotFoundError: No module named 'cv2'"

**Solution:** Install OpenCV:
```bash
pip install opencv-python
```

#### "No webcam found" error

**Solutions:**
- Ensure your webcam is connected and not in use by another application
- On Linux, check that you have permission to access `/dev/video0`
- Try different device numbers in Chronolapse configuration (`webcam_device_number`)

#### MEncoder not found

**Windows:**
1. Download MEncoder from [SourceForge](https://sourceforge.net/projects/mplayer-win32/)
2. Extract to a directory
3. Add to PATH or configure path in Chronolapse settings

**Linux:**
```bash
sudo apt-get install mencoder mplayer
```

**macOS:**
```bash
brew install ffmpeg
```

#### GUI doesn't display in Docker

**Solution:** Ensure X11 forwarding is enabled:
```bash
xhost +local:docker
export DISPLAY=:0
```

#### Permission denied on install.sh

**Solution:** Make the script executable:
```bash
chmod +x install.sh
```

### Platform-Specific Issues

#### Linux: Import error with wxPython

Install system dependencies:
```bash
sudo apt-get install libgtk-3-0 libwebkit2gtk-4.0-37
```

#### macOS: SSL certificate errors

Update certificates:
```bash
pip install --upgrade certifi
```

#### Windows: DLL load failed

Install Microsoft Visual C++ Redistributable:
- [Download here](https://support.microsoft.com/en-us/help/2977003/the-latest-supported-visual-c-downloads)

### Getting Help

If you encounter issues not covered here:

1. Check the [GitHub Issues](https://github.com/dmccoystephenson/chronolapse/issues)
2. Review the application logs (run with `-d` flag for debug output)
3. Open a new issue with:
   - Your operating system and version
   - Python version (`python --version`)
   - Full error message
   - Steps to reproduce

## Development Setup

For contributing to Chronolapse:

```bash
# Clone repository
git clone https://github.com/dmccoystephenson/chronolapse.git
cd chronolapse

# Create virtual environment
python3 -m venv venv
source venv/bin/activate  # or venv\Scripts\activate.bat on Windows

# Install development dependencies
pip install -r requirements.txt

# Run in development mode
python chronolapse.py -d  # Debug mode
```

## Verifying Installation

After installation, verify everything works:

```bash
# Test basic functionality
python chronolapse.py --help

# Run with verbose output
python chronolapse.py -v

# Run with debug output
python chronolapse.py -d
```

## Next Steps

After installation, refer to the [README.md](README.md) for:
- Configuration options
- Command-line arguments
- Usage instructions
- Feature documentation
