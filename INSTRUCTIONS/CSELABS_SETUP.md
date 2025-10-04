# 🔧 CSELabs Setup Guide

## 🎯 Accessing CSELabs for Programming Assignment 1

**Your Credentials:**
- **Username**: hasan181
- **Password**: Your UMN password
- **Assignment**: CSCI 5204/EE 5364 Programming Assignment 1

---

## 🖥️ CSELabs Access Methods

### **Method 1: Physical Lab Access (Recommended)**
```
Location: Keller Hall 1-250
Hours: Usually 24/7 (check current hours)
Login: Use your UMN credentials directly
```

**Advantages:**
- ✅ Direct access to lab machines
- ✅ No network connectivity issues
- ✅ Faster file transfers
- ✅ Easier to debug if issues occur

### **Method 2: SSH Access**
```bash
# Primary SSH servers
ssh hasan181@keller-lab.cs.umn.edu
ssh hasan181@csel-kh1250-01.cselabs.umn.edu
ssh hasan181@csel-kh1250-02.cselabs.umn.edu

# If above don't work, try these
ssh hasan181@apollo.cselabs.umn.edu
ssh hasan181@atlas.cselabs.umn.edu
```

**Advantages:**
- ✅ Work from anywhere
- ✅ Use your own keyboard/setup
- ✅ Easy copy-paste from instructions

---

## 🌐 Setting Up SSH (If Needed)

### **From Windows**
```bash
# Using PowerShell or Command Prompt
ssh hasan181@keller-lab.cs.umn.edu

# Or use PuTTY with:
# Host: keller-lab.cs.umn.edu
# Username: hasan181
# Port: 22
```

### **From Mac/Linux**
```bash
# Terminal
ssh hasan181@keller-lab.cs.umn.edu
```

### **SSH Connection Troubleshooting**
```bash
# If connection fails, try:
ssh -v hasan181@keller-lab.cs.umn.edu  # Verbose mode

# Check if you're on UMN network or VPN
# CSELabs might require UMN network access
```

---

## 📁 File Transfer Methods

### **Method 1: SCP (Recommended)**
```bash
# From your current machine
scp -r /data/munna/all/programming1 hasan181@keller-lab.cs.umn.edu:~/

# Verify transfer
ssh hasan181@keller-lab.cs.umn.edu "ls -la ~/programming1"
```

### **Method 2: rsync (Alternative)**
```bash
# More reliable for large transfers
rsync -av --progress /data/munna/all/programming1/ hasan181@keller-lab.cs.umn.edu:~/programming1/
```

### **Method 3: Git (If Available)**
```bash
# Push to GitHub from current machine
cd /data/munna/all/programming1
git init
git add .
git commit -m "Assignment solution"
git remote add origin https://github.com/yourusername/programming1.git
git push -u origin main

# Pull on CSELabs
ssh hasan181@keller-lab.cs.umn.edu
git clone https://github.com/yourusername/programming1.git
```

### **Method 4: Archive Transfer**
```bash
# Create archive
cd /data/munna/all
tar -czf programming1.tar.gz programming1/

# Transfer archive
scp programming1.tar.gz hasan181@keller-lab.cs.umn.edu:~/

# Extract on CSELabs
ssh hasan181@keller-lab.cs.umn.edu
tar -xzf programming1.tar.gz
```

---

## 🏗️ CSELabs Environment Setup

### **Initial Setup on CSELabs**
```bash
# SSH to CSELabs
ssh hasan181@keller-lab.cs.umn.edu

# Check available space
df -h

# Check scratch directory access
ls -la /export/scratch/users/
mkdir -p /export/scratch/users/hasan181

# Verify assignment files
cd ~/programming1
ls -la
./preflight_check.sh
```

### **Required Tools Verification**
```bash
# Check if tools are available
which python3     # Should show /usr/bin/python3
which git         # Should show /usr/bin/git
which make        # Should show /usr/bin/make
which gcc         # Should show /usr/bin/gcc

# Check Python packages
python3 -c "import matplotlib, numpy; print('Python packages OK')"
```

### **Module Loading (If Required)**
```bash
# Some CSELabs machines require module loading
module avail                    # See available modules
module load python3           # Load Python 3
module load gcc               # Load GCC compiler
module load git               # Load Git

# Add to your .bashrc for persistence
echo "module load python3 gcc git" >> ~/.bashrc
```

---

## 💾 Disk Space Management

### **Understanding CSELabs Storage**

**Home Directory (`~`):**
- **Location**: `/home/hasan181`
- **Size Limit**: Usually 1-5 GB
- **Persistence**: Backed up, permanent
- **Use For**: Final results, reports, important files

**Scratch Directory:**
- **Location**: `/export/scratch/users/hasan181`
- **Size Limit**: Much larger (10+ GB)
- **Persistence**: Temporary, cleaned periodically
- **Use For**: Simulation files, temporary builds

### **Disk Space Commands**
```bash
# Check disk usage
df -h                          # Overall disk space
du -sh ~/programming1          # Assignment folder size
du -sh /export/scratch/users/hasan181  # Scratch usage

# Monitor space during execution
watch -n 60 'df -h | grep scratch'
```

### **Space Management Tips**
```bash
# Clean up during execution
rm -rf /export/scratch/users/hasan181/*/build/temp/*
rm -rf /export/scratch/users/hasan181/*/.git/

# Compress logs if space is tight
gzip *.log

# Move important results to home
cp *.pdf *.png ~/
```

---

## 🔐 Security and Access

### **SSH Key Setup (Optional)**
```bash
# Generate SSH key on your machine
ssh-keygen -t rsa -b 4096 -C "hasan181@umn.edu"

# Copy public key to CSELabs
ssh-copy-id hasan181@keller-lab.cs.umn.edu

# Now you can SSH without password
ssh hasan181@keller-lab.cs.umn.edu
```

### **Screen/tmux for Long Sessions**
```bash
# Install if not available (usually pre-installed)
# tmux is preferred for this assignment

# Check availability
which tmux        # Should be available
which screen      # Backup option
```

---

## 🌐 Network and Connectivity

### **VPN Requirements**
Some CSELabs access may require UMN VPN:
- Download UMN VPN client
- Connect before accessing CSELabs
- Check with IT if you have issues

### **Network Troubleshooting**
```bash
# Test connectivity from CSELabs
ping github.com               # Should work
ping drive.google.com         # Should work
nslookup keller-lab.cs.umn.edu

# Check if firewall blocks downloads
curl -I https://github.com
```

---

## ⚡ Performance Optimization

### **Choose the Right Machine**
```bash
# Check machine specs
cat /proc/cpuinfo | grep "model name" | head -1
free -h                       # Available RAM
nproc                        # Number of CPU cores

# Choose machine with:
# - 16+ GB RAM (preferred)
# - 8+ CPU cores
# - Fast disk access
```

### **Parallel Compilation Settings**
```bash
# Adjust based on machine capabilities
export MAKEFLAGS="-j$(nproc)"  # Use all cores
export MAKEFLAGS="-j4"         # Conservative setting
```

---

## 🔧 CSELabs-Specific Commands

### **Useful CSELabs Utilities**
```bash
# Check machine information
uname -a                      # System info
lscpu                        # CPU details
lsb_release -a               # Linux distribution

# Module system (if available)
module list                  # Currently loaded modules
module avail                 # Available modules

# Queue system (if applicable)
qstat                        # Check job queue
qsub                        # Submit job to queue
```

### **Quick Environment Check**
```bash
# Run this when you first connect
echo "=== CSELabs Environment Check ==="
echo "Machine: $(hostname)"
echo "User: $(whoami)"
echo "Home: $HOME"
echo "Scratch: /export/scratch/users/$(whoami)"
echo "CPU cores: $(nproc)"
echo "RAM: $(free -h | grep Mem)"
echo "Disk space: $(df -h ~ | tail -1)"
echo "Python: $(python3 --version)"
echo "Git: $(git --version)"
```

---

## 🆘 Common CSELabs Issues

### **Issue: Cannot Access Scratch Directory**
```bash
# Solution: Create it manually
sudo mkdir -p /export/scratch/users/hasan181
sudo chown hasan181:hasan181 /export/scratch/users/hasan181
```

### **Issue: Module Not Found**
```bash
# Solution: Load required modules
module load python3 gcc git cmake
echo "module load python3 gcc git cmake" >> ~/.bashrc
```

### **Issue: Permission Denied**
```bash
# Solution: Fix permissions
chmod +x ~/programming1/*.sh
chmod +x ~/programming1/INSTRUCTIONS/*.sh
```

### **Issue: Network Download Fails**
```bash
# Solution: Try different download methods
# If gdown fails, try wget or curl
wget https://github.com/bluespec/Piccolo/archive/master.zip
```

---

**You're now ready to run your assignment on CSELabs! 🚀**

**Next Step**: Follow `STEP_BY_STEP_GUIDE.md` for complete execution instructions.