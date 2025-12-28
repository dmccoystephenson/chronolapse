# Chronolapse Dockerfile
# Multi-stage build for Chronolapse timelapse application

FROM python:3.9-slim AS base

# Set environment variables
ENV PYTHONUNBUFFERED=1 \
    DEBIAN_FRONTEND=noninteractive \
    DISPLAY=:0

# Install system dependencies required for wxPython and OpenCV
RUN apt-get update && apt-get install -y \
    # Build essentials
    build-essential \
    # wxPython dependencies
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
    # OpenCV dependencies
    libgl1-mesa-glx \
    libglib2.0-0 \
    # Video encoding (MEncoder)
    mencoder \
    mplayer \
    # X11 for GUI
    x11-apps \
    # Clean up
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy requirements first for better caching
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy application files
COPY chronolapse.py .
COPY chronolapsegui.py .
COPY chronolapsegui.wxg .
COPY easyconfig.py .
COPY chronolapse.ico .
COPY chronolapse_24.ico .
COPY README.md .

# Create default directories for captures
RUN mkdir -p screenshots webcam

# Default command
CMD ["python", "chronolapse.py"]
