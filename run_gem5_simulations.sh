#!/bin/bash

# Programming Assignment 1 - GEM5 Simulation Script
# This script sets up and runs GEM5 O3 simulations with PARSEC

X500="hasan181"
WORK_DIR="/export/scratch/users/$X500"

# Create work directory if it doesn't exist
mkdir -p "$WORK_DIR"
cd "$WORK_DIR" || { echo "Failed to access work directory"; exit 1; }

echo "=== Setting up GEM5 with PARSEC ==="
echo "Working in: $(pwd)"

# Setup PARSEC tests
if cd parsec-tests; then
    tar xvzf parsec_checkpoints_single_core.tar.gz 2>/dev/null || echo "Archive may already be extracted"
    mkdir -p ~/.cache
    ln -sf "/export/scratch/users/$X500/parsec-tests/resources" "/home/$X500/.cache/gem5"
    
    # Download and setup run script
    gdown --id 1DxShZ1JWICIAdX2mMMfrDlKS6W644fjb
    chmod +x run_parsec.sh
    cd "$WORK_DIR"
else
    echo "ERROR: parsec-tests directory not found"
    exit 1
fi

# Clone and build GEM5
echo "Cloning and building GEM5..."
git clone --branch v23.0.0.0 https://github.com/gem5/gem5.git
cd gem5
scons build/X86_MESI_Two_Level/gem5.opt -j8

cd ..

# Function to run simulation and extract results
run_simulation() {
    local config_name="$1"
    echo "Running simulation with configuration: $config_name"
    ./run_parsec.sh
    
    # Find simulation results
    for benchmark_dir in */; do
        if [ -d "$benchmark_dir/m5out" ]; then
            echo "=== Results for $config_name - $benchmark_dir ==="
            if [ -f "$benchmark_dir/m5out/stats.txt" ]; then
                echo "CPI:"
                grep "cpi" "$benchmark_dir/m5out/stats.txt"
                echo "Host Tick Rate:"
                grep -i "hosttickrate\|host_tick_rate" "$benchmark_dir/m5out/stats.txt"
            fi
            # Backup results
            mkdir -p results/$config_name
            cp -r "$benchmark_dir/m5out" "results/$config_name/$benchmark_dir"
        fi
    done
}

# Create results directory
mkdir -p results

# Run baseline simulation
echo "Running baseline simulation..."
run_simulation "baseline"

# Modify GEM5 parameters and run additional simulations
modify_and_run() {
    local lq_entries="$1"
    local sq_entries="$2"
    local issue_width="$3"
    local rob_entries="$4"
    local config_name="LQ${lq_entries}_SQ${sq_entries}_IW${issue_width}_ROB${rob_entries}"
    
    echo "Modifying GEM5 parameters: LQ=$lq_entries, SQ=$sq_entries, IW=$issue_width, ROB=$rob_entries"
    
    # Create backup of original file
    cp gem5/src/cpu/o3/BaseO3CPU.py gem5/src/cpu/o3/BaseO3CPU.py.backup
    
    # Modify parameters
    sed -i "s/LQEntries = Param.Unsigned(32/LQEntries = Param.Unsigned($lq_entries/" gem5/src/cpu/o3/BaseO3CPU.py
    sed -i "s/SQEntries = Param.Unsigned(32/SQEntries = Param.Unsigned($sq_entries/" gem5/src/cpu/o3/BaseO3CPU.py
    sed -i "s/issueWidth = Param.Unsigned(8/issueWidth = Param.Unsigned($issue_width/" gem5/src/cpu/o3/BaseO3CPU.py
    sed -i "s/numROBEntries = Param.Unsigned(192/numROBEntries = Param.Unsigned($rob_entries/" gem5/src/cpu/o3/BaseO3CPU.py
    
    # Recompile GEM5
    echo "Recompiling GEM5..."
    cd gem5
    scons build/X86_MESI_Two_Level/gem5.opt -j8
    cd ..
    
    # Run simulation
    run_simulation "$config_name"
    
    # Restore original file
    cp gem5/src/cpu/o3/BaseO3CPU.py.backup gem5/src/cpu/o3/BaseO3CPU.py
}

# Test different configurations
echo "Testing different O3 configurations..."

# Configuration 1: Smaller sizes
modify_and_run 16 16 4 128

# Configuration 2: Larger sizes
modify_and_run 64 64 12 384

# Configuration 3: Mixed sizes
modify_and_run 16 64 8 256

echo "=== GEM5 Simulations Complete ==="
echo "Results saved in results/ directory"