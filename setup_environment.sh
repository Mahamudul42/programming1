#!/bin/bash

# Programming Assignment 1 - Environment Setup Script
# Replace <X500> with your actual X500 ID

# Set your X500 ID here
X500="hasan181"

echo "Setting up environment for Programming Assignment 1..."

# Create working directory in scratch
mkdir -p /export/scratch/users/$X500
cd /export/scratch/users/$X500

# Install gdown for downloading files
pip install gdown

# Download and extract handout
echo "Downloading handout..."
gdown --id 1_h0-LZNxbU-v2paqDoEo7UVcR6Cz-YqC
tar xvzf handout_5204_Fall2025.tar.gz

# Set PATH for tools
export PATH=/export/scratch/users/$X500/bin:$PATH

# Download Verilator patch
echo "Downloading Verilator patch..."
gdown --id 1B1oCjq7ijsJU7pRJFiNFL5Oxo_V1oyFj
tar xvzf patch_for_verilator.tar.gz
export VERILATOR_ROOT=/export/scratch/users/$X500/verilator-install

# Make scripts executable
chmod +x *.sh

echo "Environment setup complete!"
echo "Next steps:"
echo "1. Clone and build Piccolo, Flute, and Toooba"
echo "2. Set up GEM5 with PARSEC"
echo "3. Run ALU tests with COCOTB"