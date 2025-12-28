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

REM Get and check Python version
for /f "tokens=2" %%i in ('python --version 2^>^&1') do set PYTHON_VERSION=%%i
echo [+] Found Python %PYTHON_VERSION%

REM Extract major and minor version numbers
for /f "tokens=1,2 delims=." %%a in ("%PYTHON_VERSION%") do (
    set PYTHON_MAJOR=%%a
    set PYTHON_MINOR=%%b
)

REM Check if version is 3.7 or higher
if %PYTHON_MAJOR% LSS 3 (
    echo [X] Error: Python 3.7 or higher is required
    echo     You have Python %PYTHON_VERSION%
    echo     Please install Python 3.7+ from https://www.python.org
    pause
    exit /b 1
)
if %PYTHON_MAJOR% EQU 3 if %PYTHON_MINOR% LSS 7 (
    echo [X] Error: Python 3.7 or higher is required
    echo     You have Python %PYTHON_VERSION%
    echo     Please install Python 3.7+ from https://www.python.org
    pause
    exit /b 1
)

echo [+] Python version check passed

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

REM Install Python dependencies
echo.
echo Installing Python dependencies...
pip install -r requirements.txt

REM Install Windows-specific dependencies
echo.
echo Installing Windows-specific dependencies...
pip install -r requirements-windows.txt

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
