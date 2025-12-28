@echo off
REM Chronolapse Installation Script for Windows
REM Automated installation script

echo ======================================
echo Chronolapse Installation Script
echo ======================================
echo.

REM Check for Python
python --version >nul 2>&1
if errorlevel 1 (
    echo [X] Error: Python is not installed or not in PATH
    echo     Please install Python 3.7 or higher from https://www.python.org
    pause
    exit /b 1
)

echo [+] Found Python
python --version

REM Check for pip
pip --version >nul 2>&1
if errorlevel 1 (
    echo [X] Error: pip is not installed
    echo     Please install pip and try again
    pause
    exit /b 1
)

echo [+] Found pip

REM Create virtual environment
echo.
echo Creating virtual environment...
if exist venv (
    echo [!] Virtual environment already exists. Skipping creation.
) else (
    python -m venv venv
    echo [+] Virtual environment created
)

REM Activate virtual environment
echo Activating virtual environment...
call venv\Scripts\activate.bat

REM Upgrade pip
echo Upgrading pip...
python -m pip install --upgrade pip

REM Install basic dependencies
echo.
echo Installing Python dependencies...
pip install numpy
pip install opencv-python
pip install Pillow

REM Install wxPython
echo.
echo Installing wxPython...
pip install wxPython

REM Install Windows-specific dependencies
echo.
echo Installing Windows-specific dependencies...
pip install pywin32
pip install pefile

REM Optional: Install PyInstaller for building executable
echo.
echo Do you want to install PyInstaller (for building executable)?
set /p INSTALL_PYINSTALLER="Install PyInstaller? (y/n): "
if /i "%INSTALL_PYINSTALLER%"=="y" (
    echo Installing PyInstaller...
    pip install pyinstaller
    echo [+] PyInstaller installed
)

REM Optional: Install MEncoder
echo.
echo ======================================
echo [!] Important: MEncoder Installation
echo ======================================
echo.
echo Chronolapse requires MEncoder for video rendering.
echo.
echo Please download MEncoder from:
echo https://sourceforge.net/projects/mplayer-win32/
echo.
echo Extract MEncoder and either:
echo 1. Add it to your system PATH, or
echo 2. Specify the path in Chronolapse settings
echo.

echo.
echo ======================================
echo [+] Installation Complete!
echo ======================================
echo.
echo To run Chronolapse:
echo   1. Activate the virtual environment:
echo      venv\Scripts\activate.bat
echo   2. Run the application:
echo      python chronolapse.py
echo.
echo Or use the quick start script:
echo   run.bat
echo.
pause
