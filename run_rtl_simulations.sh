#!/bin/bash

# Programming Assignment 1 - RTL Simulation Script
# This script builds and runs Piccolo, Flute, and Toooba processors

X500="hasan181"
WORK_DIR="/export/scratch/users/$X500"

# Create work directory if it doesn't exist
mkdir -p "$WORK_DIR"
cd "$WORK_DIR" || { echo "Failed to access work directory"; exit 1; }

echo "=== Building and Testing RTL Processors ==="
echo "Working in: $(pwd)"

# Function to measure execution time
measure_time() {
    start_time=$(date +%s.%N)
    eval "$1"
    end_time=$(date +%s.%N)
    if command -v bc &> /dev/null; then
        execution_time=$(echo "$end_time - $start_time" | bc)
        echo "Execution time: $execution_time seconds"
    else
        echo "Execution time: $((${end_time%.*} - ${start_time%.*})) seconds (approximate)"
    fi
}

# 1. PICCOLO (RV32 in-order)
echo "1. Setting up Piccolo..."
if [ ! -d "Piccolo" ]; then
    git clone https://github.com/bluespec/Piccolo.git
    ./patch_piccolo.sh
fi

echo "Building Piccolo with Verilator..."
if cd Piccolo/builds/RV32ACIMU_Piccolo_verilator; then
    measure_time "make simulator"
    echo "Running Piccolo tests..."
    measure_time "make test"
    measure_time "make isa_tests"
    
    # Extract cycles/second from logs
    if [ -d "Logs" ]; then
        echo "Piccolo Verilator Results:"
        grep -r "cycles/second" Logs/ | tail -5 || echo "No cycles/second data found"
    fi
    cd "$WORK_DIR"
else
    echo "ERROR: Failed to access Piccolo Verilator build directory"
fi

echo "Building Piccolo with Bluesim..."
if cd Piccolo/builds/RV32ACIMU_Piccolo_bluesim; then
    measure_time "make compile simulator"
    measure_time "make test"
    measure_time "make isa_tests"
    
    if [ -d "Logs" ]; then
        echo "Piccolo Bluesim Results:"
        grep -r "cycles/second" Logs/ | tail -5 || echo "No cycles/second data found"
    fi
    cd "$WORK_DIR"
else
    echo "ERROR: Failed to access Piccolo Bluesim build directory"
fi

# 2. FLUTE (RV64GC in-order)
echo "2. Setting up Flute..."
if [ ! -d "Flute" ]; then
    git clone https://github.com/bluespec/Flute.git
    ./patch_flute.sh
fi

echo "Building Flute with Verilator..."
cd Flute/builds/Flute_RV64GC_MSU_WB_L1_L2_verilator_tohost
measure_time "make simulator"
measure_time "make test"
measure_time "make isa_tests"

if [ -d "Logs" ]; then
    echo "Flute Verilator Results:"
    grep -r "cycles/second" Logs/ | tail -5
fi

cd $WORK_DIR

echo "Building Flute with Bluesim..."
cd Flute/builds/Flute_RV64GC_MSU_WB_L1_L2_bluesim_tohost
measure_time "make compile simulator"
measure_time "make test"
measure_time "make isa_tests"

if [ -d "Logs" ]; then
    echo "Flute Bluesim Results:"
    grep -r "cycles/second" Logs/ | tail -5
fi

cd $WORK_DIR

# 3. TOOOBA (RV64GC out-of-order)
echo "3. Setting up Toooba..."
if [ ! -d "Toooba" ]; then
    git clone https://github.com/bluespec/Toooba.git
    cd Toooba
    git submodule update --init --recursive
    cd ..
    gdown --id 1dTKq82tK2E7YNTjIN2YLlJup2hZ7XTor
    tar xvzf patch_toooba_time.tar.gz
    ./patch_toooba.sh
fi

echo "Building Toooba with Verilator..."
cd Toooba/builds/RV64ACDFIMSU_Toooba_verilator
measure_time "make simulator"
measure_time "make test"
measure_time "make isa_tests"

if [ -d "Logs" ]; then
    echo "Toooba Verilator Results:"
    grep -r "cycles/second" Logs/ | tail -5
fi

cd $WORK_DIR

echo "Building Toooba with Bluesim..."
cd Toooba/builds/RV64ACDFIMSU_Toooba_bluesim
measure_time "make compile simulator"
measure_time "make test"

if [ -d "Logs" ]; then
    echo "Toooba Bluesim Results:"
    grep -r "cycles/second" Logs/ | tail -5
fi

echo "=== RTL Simulation Complete ==="