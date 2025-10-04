#!/bin/bash

# Pre-flight check script for Programming Assignment 1
# This script validates the environment and setup before running the main assignment

echo "=== Programming Assignment 1 - Pre-flight Check ==="
echo "Student: hasan181"
echo "Teammate: suh00051"
echo "Date: $(date)"
echo

# Function to check command availability
check_command() {
    local cmd="$1"
    local required="$2"
    
    if command -v "$cmd" &> /dev/null; then
        echo "✓ $cmd is available"
        return 0
    else
        if [ "$required" = "required" ]; then
            echo "✗ $cmd is NOT available (REQUIRED)"
            return 1
        else
            echo "⚠ $cmd is NOT available (optional)"
            return 0
        fi
    fi
}

# Function to check Python packages
check_python_package() {
    local package="$1"
    
    if python3 -c "import $package" 2>/dev/null; then
        echo "✓ Python package '$package' is available"
        return 0
    else
        echo "⚠ Python package '$package' is NOT available (will be installed)"
        return 1
    fi
}

# Check basic tools
echo "1. Checking basic tools..."
check_command "bash" "required"
check_command "python3" "required"
check_command "pip" "required"
check_command "git" "required"
check_command "make" "required"
check_command "tar" "required"
check_command "gdown" "optional"

# Check optional tools
echo
echo "2. Checking simulation tools..."
check_command "verilator" "optional"
check_command "iverilog" "optional"
check_command "scons" "optional"
check_command "bc" "optional"

# Check Python packages
echo
echo "3. Checking Python packages..."
check_python_package "matplotlib"
check_python_package "numpy"

# Check directories and permissions
echo
echo "4. Checking directories and permissions..."

WORK_DIR="/export/scratch/users/hasan181"
HOME_DIR="/home/hasan181"

if [ -d "/export/scratch/users" ]; then
    echo "✓ Scratch directory is accessible"
    
    if [ -w "/export/scratch/users" ]; then
        echo "✓ Can write to scratch directory"
        mkdir -p "$WORK_DIR"
        echo "✓ Created work directory: $WORK_DIR"
    else
        echo "✗ Cannot write to scratch directory"
    fi
else
    echo "✗ Scratch directory not accessible"
fi

if [ -d "$HOME_DIR" ]; then
    echo "✓ Home directory is accessible: $HOME_DIR"
else
    echo "⚠ Home directory not found: $HOME_DIR"
fi

# Check available disk space
echo
echo "5. Checking disk space..."
if df -h "/export/scratch" 2>/dev/null; then
    available=$(df -h "/export/scratch" | awk 'NR==2 {print $4}')
    echo "Available space in scratch: $available"
    
    # Extract numeric value (remove G, M, etc.)
    numeric_space=$(echo "$available" | sed 's/[^0-9]*//g')
    if [ "$numeric_space" -gt 10 ]; then
        echo "✓ Sufficient disk space available"
    else
        echo "⚠ Limited disk space available"
    fi
else
    echo "⚠ Cannot check disk space"
fi

# Check network connectivity for downloads
echo
echo "6. Checking network connectivity..."
if ping -c 1 github.com &> /dev/null; then
    echo "✓ GitHub is accessible"
else
    echo "⚠ GitHub connectivity issues"
fi

if ping -c 1 drive.google.com &> /dev/null; then
    echo "✓ Google Drive is accessible"
else
    echo "⚠ Google Drive connectivity issues"
fi

# Verify script files exist
echo
echo "7. Checking script files..."
script_files=(
    "setup_environment.sh"
    "run_rtl_simulations.sh"
    "run_gem5_simulations.sh"
    "run_alu_tests.sh"
    "run_complete_assignment.sh"
    "analyze_results.py"
    "enhanced_alu_test.py"
    "report_template.tex"
)

for script in "${script_files[@]}"; do
    if [ -f "$script" ]; then
        if [ -x "$script" ] || [[ "$script" == *.py ]] || [[ "$script" == *.tex ]]; then
            echo "✓ $script exists and is executable/readable"
        else
            echo "⚠ $script exists but may not be executable"
            chmod +x "$script" 2>/dev/null
        fi
    else
        echo "✗ $script is missing"
    fi
done

# Check if gdown can be installed
echo
echo "8. Testing gdown installation..."
if ! command -v gdown &> /dev/null; then
    echo "Installing gdown..."
    if pip install gdown --user; then
        echo "✓ gdown installed successfully"
        # Update PATH to include user bin
        export PATH="$HOME/.local/bin:$PATH"
    else
        echo "⚠ Failed to install gdown"
    fi
fi

# Summary
echo
echo "=== Pre-flight Check Summary ==="
echo "If you see any ✗ errors above, please address them before running the assignment."
echo "⚠ warnings are usually fine and will be handled automatically."
echo
echo "To run the complete assignment:"
echo "  ./run_complete_assignment.sh"
echo
echo "To run individual components:"
echo "  ./setup_environment.sh"
echo "  ./run_rtl_simulations.sh"
echo "  ./run_gem5_simulations.sh"
echo "  ./run_alu_tests.sh"
echo
echo "Expected runtime: 8-14 hours total"
echo "Make sure to monitor disk space during execution!"