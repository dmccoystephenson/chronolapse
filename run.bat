@echo off
REM Quick start script for Chronolapse on Windows

if exist venv\Scripts\activate.bat (
    call venv\Scripts\activate.bat
    python chronolapse.py %*
) else (
    echo Error: Virtual environment not found.
    echo Please run install.bat first.
    pause
    exit /b 1
)
