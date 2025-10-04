# 🐛 Troubleshooting Guide

## 🎯 Common Issues and Solutions

This guide covers the most likely problems you'll encounter and how to fix them quickly.

---

## 🔧 Setup and Connection Issues

### **Problem: Cannot SSH to CSELabs**
```bash
# Error: Connection refused or timeout

# Solutions to try:
ssh hasan181@keller-lab.cs.umn.edu          # Primary
ssh hasan181@csel-kh1250-01.cselabs.umn.edu # Alternative
ssh hasan181@apollo.cselabs.umn.edu         # Backup

# If still failing:
ping keller-lab.cs.umn.edu  # Check if reachable
# May need UMN VPN or network access
```

### **Problem: File Transfer Fails**
```bash
# Error: Permission denied or connection issues

# Solution 1: Use rsync instead of scp
rsync -av --progress programming1/ hasan181@keller-lab.cs.umn.edu:~/programming1/

# Solution 2: Archive and transfer
tar -czf programming1.tar.gz programming1/
scp programming1.tar.gz hasan181@keller-lab.cs.umn.edu:~/
ssh hasan181@keller-lab.cs.umn.edu "tar -xzf programming1.tar.gz"

# Solution 3: Use multiple smaller transfers
scp programming1/*.sh hasan181@keller-lab.cs.umn.edu:~/programming1/
scp programming1/*.py hasan181@keller-lab.cs.umn.edu:~/programming1/
```

### **Problem: Preflight Check Fails**
```bash
# Error: Tools not found or permissions issues

# Fix permissions
chmod +x ~/programming1/*.sh
chmod +x ~/programming1/INSTRUCTIONS/*.sh

# Install missing tools (if admin access)
sudo apt-get update
sudo apt-get install build-essential git python3-pip

# Load modules (if module system available)
module load python3 gcc git
echo "module load python3 gcc git" >> ~/.bashrc
```

---

## 💾 Disk Space Issues

### **Problem: "No space left on device"**
```bash
# Check disk usage
df -h
du -sh /export/scratch/users/hasan181/*

# Emergency cleanup
cd /export/scratch/users/hasan181
rm -rf */build/temp/*        # Remove temp build files
rm -rf */.git/                # Remove git histories
rm -rf */logs/old/*           # Remove old logs
gzip *.log                    # Compress large logs

# Move results to home directory
cp ~/programming1/*.pdf ~/
cp ~/programming1/*.png ~/
cp ~/programming1/*.txt ~/
```

### **Problem: Scratch Directory Not Accessible**
```bash
# Create scratch directory
mkdir -p /export/scratch/users/hasan181

# Fix ownership (if needed)
sudo chown hasan181:hasan181 /export/scratch/users/hasan181

# Alternative: Use home directory (not recommended)
# Edit scripts to use ~/workspace instead of scratch
```

### **Problem: Quota Exceeded**
```bash
# Check quota
quota -u hasan181

# Clean up home directory
cd ~
rm -rf .cache/*
rm -rf .local/share/Trash/*
rm -rf *.core

# Use scratch for large files only
mv large_files /export/scratch/users/hasan181/
```

---

## 🔨 Compilation and Build Issues

### **Problem: "make: command not found"**
```bash
# Install build tools
sudo apt-get install build-essential

# Or load module
module load gcc
module load cmake

# Verify installation
which make gcc g++
```

### **Problem: "Permission denied" During Build**
```bash
# Fix script permissions
find ~/programming1 -name "*.sh" -exec chmod +x {} \;

# Fix directory permissions
chmod -R u+rwx ~/programming1
chmod -R u+rwx /export/scratch/users/hasan181
```

### **Problem: GCC/Compiler Errors**
```bash
# Error: Compiler too old or missing features

# Load newer compiler
module load gcc/9.3.0  # or newer version
export CC=gcc-9
export CXX=g++-9

# Alternative: Use system compiler
which gcc
gcc --version  # Should be 7.0 or newer

# For Verilator specific issues
export VERILATOR_ROOT=/export/scratch/users/hasan181/verilator-install
export PATH=$VERILATOR_ROOT/bin:$PATH
```

### **Problem: Python Package Missing**
```bash
# Error: ModuleNotFoundError

# Install missing packages
pip3 install --user matplotlib numpy cocotb pytest

# Create virtual environment
python3 -m venv ~/venv
source ~/venv/bin/activate
pip install matplotlib numpy cocotb pytest

# Add to path
echo 'export PATH=$HOME/.local/bin:$PATH' >> ~/.bashrc
source ~/.bashrc
```

---

## 🌐 Network and Download Issues

### **Problem: "gdown" Download Fails**
```bash
# Error: Network timeout or access denied

# Solution 1: Retry with different method
pip3 install --user gdown --upgrade
gdown --id 1_h0-LZNxbU-v2paqDoEo7UVcR6Cz-YqC --output handout.tar.gz

# Solution 2: Use wget/curl
wget https://drive.google.com/uc?id=1_h0-LZNxbU-v2paqDoEo7UVcR6Cz-YqC -O handout.tar.gz

# Solution 3: Manual download
# Download files manually and copy via SCP
```

### **Problem: Git Clone Fails**
```bash
# Error: Connection timeout or SSL issues

# Solution 1: Use HTTPS instead of SSH
git clone https://github.com/bluespec/Piccolo.git

# Solution 2: Increase timeout
git config --global http.postBuffer 1048576000
git config --global http.lowSpeedLimit 0
git config --global http.lowSpeedTime 999999

# Solution 3: Shallow clone
git clone --depth 1 https://github.com/bluespec/Piccolo.git
```

### **Problem: PARSEC Download Issues**
```bash
# Error: Large file download interrupted

# Use rsync for resumable downloads
rsync -av --partial --progress source dest

# Or use aria2 for multi-threaded downloads
aria2c -x 4 -s 4 "download_url"

# Manual approach: Download in parts
curl -C - -O "large_file_url"  # Resume interrupted download
```

---

## ⚙️ Simulation Runtime Issues

### **Problem: Simulation Hangs**
```bash
# Check if processes are actually running
ps aux | grep -E "(verilator|bluesim|gem5)" | grep hasan181

# Check system load
top
htop  # If available

# If hanging, kill and restart
pkill -f "verilator"
pkill -f "bluesim"
pkill -f "gem5"

# Restart with reduced parallelism
export MAKEFLAGS="-j2"  # Instead of -j8
```

### **Problem: "Segmentation fault"**
```bash
# Error: Simulation crashes

# Solution 1: Reduce memory usage
export OMP_NUM_THREADS=2
ulimit -v 4000000  # Limit virtual memory

# Solution 2: Use different simulator
# If Verilator crashes, try Bluesim
# If Bluesim crashes, try Verilator

# Solution 3: Run tests individually
make test TEST=rv32ui-p-add  # One test at a time
```

### **Problem: GEM5 Build Fails**
```bash
# Error: SCons build errors

# Solution 1: Clean and rebuild
cd gem5
scons build/X86_MESI_Two_Level/gem5.opt --clean
scons build/X86_MESI_Two_Level/gem5.opt -j4

# Solution 2: Use different build target
scons build/X86/gem5.opt -j4

# Solution 3: Install dependencies
sudo apt-get install scons python3-dev zlib1g-dev
```

---

## 🧪 ALU Testing Issues

### **Problem: COCOTB Tests Fail**
```bash
# Error: ImportError or test failures

# Solution 1: Fix Python environment
cd HW-cocotb-alu
python3 -m venv .venv
source .venv/bin/activate
pip install --upgrade pip
pip install cocotb cocotb-coverage pytest

# Solution 2: Use system packages
pip3 install --user cocotb pytest

# Solution 3: Check Verilog simulator
which icarus  # Should be available
sudo apt-get install iverilog  # If missing
```

### **Problem: ALU Test Timeouts**
```bash
# Error: Tests take too long or timeout

# Solution 1: Reduce test count
# Edit enhanced_alu_test.py
# Change: for _ in range(100):  # 100 random tests
# To: for _ in range(10):       # 10 random tests

# Solution 2: Use faster simulator
# Try verilator instead of icarus
make SIM=verilator  # If available
```

---

## 🔍 tmux and Session Issues

### **Problem: tmux Session Lost**
```bash
# Error: Can't find session

# List all sessions
tmux list-sessions

# If no sessions found but processes running
ps aux | grep hasan181 | grep -E "(assignment|simulation)"

# Create new session around existing process
tmux new-session -d -s recovery

# Check for completion
grep -r "Assignment Complete" ~/programming1/
```

### **Problem: Can't Detach from tmux**
```bash
# If Ctrl+B, D doesn't work

# Try these key combinations:
Ctrl+B, then :detach-client
Ctrl+B, then d (lowercase)

# Force detach from outside
tmux detach-client -t assignment1

# If session is frozen
tmux kill-session -t assignment1
# Then restart
tmux new-session -s assignment1
```

---

## 📊 Results and Analysis Issues

### **Problem: No Output Files Generated**
```bash
# Check if scripts completed
tail -50 ~/programming1/*.txt

# Look for error messages
grep -i error ~/programming1/*.txt
grep -i fail ~/programming1/*.txt

# Check process status
ps aux | grep hasan181

# Manually verify results location
find /export/scratch/users/hasan181 -name "*.log" -type f
find ~/programming1 -name "*.png" -type f
```

### **Problem: Plots Not Generated**
```bash
# Error: matplotlib or Python issues

# Check Python setup
python3 -c "import matplotlib; print('OK')"

# Install missing packages
pip3 install --user matplotlib numpy

# Run plot generation manually
cd ~/programming1
python3 analyze_results.py

# Alternative: Use analysis script
chmod +x generate_pdf.sh
./generate_pdf.sh
```

### **Problem: PDF Compilation Fails**
```bash
# Error: LaTeX errors

# Install LaTeX packages
sudo apt-get install texlive-latex-extra

# Check LaTeX installation
which pdflatex

# Compile with error details
pdflatex -interaction=nonstopmode report_template.tex

# Fix common LaTeX issues
# Remove problematic characters
# Check image file paths
# Verify table formatting
```

---

## 🚨 Emergency Recovery

### **Complete System Reset**
```bash
# If everything goes wrong

# 1. Kill all processes
pkill -f "assignment"
pkill -f "verilator"
pkill -f "bluesim"
pkill -f "gem5"

# 2. Clean workspace
rm -rf /export/scratch/users/hasan181/*
cd ~/programming1

# 3. Start fresh
./preflight_check.sh
./run_complete_assignment.sh
```

### **Partial Recovery (Save Progress)**
```bash
# If simulation partially completed

# Save what you have
mkdir -p ~/backup
cp ~/programming1/*.txt ~/backup/
cp /export/scratch/users/hasan181/*/Logs/*.log ~/backup/

# Restart only failed components
# Edit run_complete_assignment.sh
# Comment out completed sections
# Run remaining parts
```

---

## 📞 Getting Help

### **Information to Collect Before Asking for Help**
```bash
# System information
uname -a > debug_info.txt
echo "Home dir: $(du -sh ~)" >> debug_info.txt
echo "Scratch dir: $(du -sh /export/scratch/users/hasan181)" >> debug_info.txt

# Error logs
grep -i error ~/programming1/*.txt > errors.txt
tail -100 ~/programming1/*.txt > last_output.txt

# Process status
ps aux | grep hasan181 > processes.txt
```

### **CSELabs Support**
- Email: help@cs.umn.edu
- Include: Student ID (hasan181), error messages, debug_info.txt

### **Course Support**
- Check course Canvas for announcements
- Post in course discussion forum
- Office hours for TA/instructor help

---

**Most issues can be resolved by checking disk space, permissions, and restarting processes. Don't panic! 🚀**