#!/bin/bash
# Quick start script for Chronolapse

# Activate virtual environment
if [ -d "venv" ]; then
    source venv/bin/activate
    python chronolapse.py "$@"
else
    echo "Error: Virtual environment not found."
    echo "Please run install.sh first."
    exit 1
fi
