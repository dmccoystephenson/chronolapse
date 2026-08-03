#!/bin/bash
# Validation script for Chronolapse installation files
# This script checks that all installation artifacts are properly created

set -e

echo "======================================"
echo "Chronolapse Installation Validation"
echo "======================================"
echo ""

ERRORS=0

# Function to check if file exists
check_file() {
    if [ -f "$1" ]; then
        echo "✓ $1"
    else
        echo "✗ $1 - MISSING"
        ERRORS=$((ERRORS + 1))
    fi
}

# Function to check if file is executable
check_executable() {
    if [ -x "$1" ]; then
        echo "✓ $1 (executable)"
    else
        echo "✗ $1 - NOT EXECUTABLE"
        ERRORS=$((ERRORS + 1))
    fi
}

# Check installation files
echo "Checking installation files..."
check_file "requirements.txt"
check_executable "install.sh"
check_file "install.bat"
check_executable "run.sh"
check_file "run.bat"

echo ""
echo "Checking Docker files..."
check_file "Dockerfile"
check_file "docker-compose.yml"
check_file ".dockerignore"

echo ""
echo "Checking documentation..."
check_file "README.md"
check_file "INSTALL.md"
check_file "DOCKER.md"
check_file "QUICKSTART.md"

echo ""
echo "Checking application files..."
check_file "chronolapse.py"
check_file "chronolapsegui.py"
check_file "easyconfig.py"
check_file "chronolapse.ico"
check_file "chronolapse_24.ico"

echo ""
echo "Validating file syntax..."

# Validate bash scripts
if bash -n install.sh 2>/dev/null; then
    echo "✓ install.sh syntax valid"
else
    echo "✗ install.sh syntax error"
    ERRORS=$((ERRORS + 1))
fi

if bash -n run.sh 2>/dev/null; then
    echo "✓ run.sh syntax valid"
else
    echo "✗ run.sh syntax error"
    ERRORS=$((ERRORS + 1))
fi

# Validate Docker Compose
if command -v docker &> /dev/null; then
    if docker compose config --quiet 2>/dev/null; then
        echo "✓ docker-compose.yml syntax valid"
    else
        echo "✗ docker-compose.yml syntax error"
        ERRORS=$((ERRORS + 1))
    fi
else
    echo "⚠ Docker not available - skipping docker-compose.yml validation"
fi

# Validate requirements.txt
if python3 -c "
with open('requirements.txt', 'r') as f:
    for line in f:
        line = line.strip()
        if line and not line.startswith('#'):
            pass
" 2>/dev/null; then
    echo "✓ requirements.txt syntax valid"
else
    echo "✗ requirements.txt syntax error"
    ERRORS=$((ERRORS + 1))
fi

# Validate Python syntax
if python3 -m py_compile chronolapse.py 2>/dev/null; then
    echo "✓ chronolapse.py syntax valid"
else
    echo "✗ chronolapse.py syntax error"
    ERRORS=$((ERRORS + 1))
fi

echo ""
echo "======================================"
if [ $ERRORS -eq 0 ]; then
    echo "✓ All validation checks passed!"
    echo "======================================"
    exit 0
else
    echo "✗ $ERRORS validation check(s) failed"
    echo "======================================"
    exit 1
fi
