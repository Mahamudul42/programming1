#!/bin/bash

# Programming Assignment 1 - ALU Testing Script
# This script sets up and runs COCOTB tests for the ALU

X500="hasan181"
WORK_DIR="/export/scratch/users/$X500"

# Create work directory if it doesn't exist
mkdir -p "$WORK_DIR"
cd "$WORK_DIR" || { echo "Failed to access work directory"; exit 1; }

echo "=== Setting up ALU Tests with COCOTB ==="
echo "Working in: $(pwd)"

# Navigate to ALU test directory
if cd HW-cocotb-alu; then
    # Create virtual environment
    echo "Creating Python virtual environment..."
    python3 -m venv .venv
    
    # Activate virtual environment
    source .venv/bin/activate
    
    # Install required packages
    echo "Installing COCOTB and dependencies..."
    pip install --upgrade pip
    pip install cocotb cocotb-coverage pytest
    
    # Run ALU tests
    echo "Running ALU tests..."
    if cd sim; then
        # Run tests with icarus simulator
        make SIM=icarus
        cd ..
    else
        echo "ERROR: sim directory not found"
    fi
    
    # Deactivate virtual environment
    deactivate
    cd "$WORK_DIR"
else
    echo "ERROR: HW-cocotb-alu directory not found"
    echo "Make sure the handout was properly extracted"
fi

# Check test results
echo "=== ALU Test Results ==="
ALU_DIR="$WORK_DIR/HW-cocotb-alu"
if [ -f "$ALU_DIR/results.xml" ]; then
    echo "Test results found in results.xml"
    cat "$ALU_DIR/results.xml"
fi

# Look for pass/fail in output logs
if [ -f "$ALU_DIR/sim/sim_build/icarus/results.xml" ]; then
    echo "Detailed results:"
    cat "$ALU_DIR/sim/sim_build/icarus/results.xml"
fi

# Check for any error logs
if [ -d "$ALU_DIR/sim/sim_build" ]; then
    echo "Looking for error logs..."
    find "$ALU_DIR/sim/sim_build" -name "*.log" -exec echo "=== {} ===" \; -exec head -20 {} \;
fi

echo "=== ALU Testing Complete ==="