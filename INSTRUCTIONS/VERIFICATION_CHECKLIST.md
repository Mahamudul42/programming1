# ✅ Verification Checklist

## 🎯 Pre-Execution Verification

**Complete this checklist BEFORE starting the assignment to avoid issues.**

---

## 📋 Environment Verification

### **CSELabs Access**
- [ ] Can SSH to CSELabs: `ssh hasan181@keller-lab.cs.umn.edu`
- [ ] Can access scratch directory: `ls /export/scratch/users/`
- [ ] Have sufficient disk space: `df -h` (at least 15GB free)
- [ ] Home directory accessible: `cd ~ && pwd`

### **File Transfer Verification**
- [ ] Assignment files copied to CSELabs: `ls ~/programming1/`
- [ ] All scripts present: `ls ~/programming1/*.sh`
- [ ] Instructions folder copied: `ls ~/programming1/INSTRUCTIONS/`
- [ ] Scripts are executable: `ls -la ~/programming1/*.sh`

### **Tool Availability**
- [ ] Python 3 available: `python3 --version` (≥3.7)
- [ ] Git available: `git --version`
- [ ] Make available: `make --version`
- [ ] GCC available: `gcc --version` (≥7.0)
- [ ] Basic Python packages: `python3 -c "import matplotlib, numpy"`

---

## 📋 Assignment Setup Verification

### **Script Permissions**
```bash
# Run this verification
cd ~/programming1
find . -name "*.sh" | xargs ls -la

# All should show: -rwxr-xr-x (executable)
# If not, run: chmod +x *.sh INSTRUCTIONS/*.sh
```

### **Preflight Check**
```bash
# Must pass without errors
./preflight_check.sh

# Expected output:
# ✓ bash is available
# ✓ python3 is available
# ✓ git is available
# ✓ make is available
# ✓ Scratch directory is accessible
```

### **ID Configuration**
- [ ] Scripts contain correct ID: `grep -r "hasan181" *.sh`
- [ ] Report template has team names: `grep -A 3 "author" report_template.tex`
- [ ] No placeholder IDs remain: `grep -r "your_x500" *.sh` (should be empty)

---

## 📋 Disk Space Management

### **Scratch Directory Setup**
```bash
# Verify scratch access
mkdir -p /export/scratch/users/hasan181
cd /export/scratch/users/hasan181
touch test_file && rm test_file

# Check available space
df -h /export/scratch | tail -1
# Should show >15GB available
```

### **Space Monitoring Setup**
```bash
# Create monitoring script
cat > ~/check_space.sh << 'EOF'
#!/bin/bash
echo "=== Disk Space Check ==="
echo "Time: $(date)"
echo "Scratch: $(df -h /export/scratch | tail -1)"
echo "Home: $(df -h ~ | tail -1)"
echo "Assignment size: $(du -sh ~/programming1)"
EOF

chmod +x ~/check_space.sh
./check_space.sh
```

---

## 📋 Network Connectivity

### **Download Capability**
```bash
# Test network access
ping -c 3 github.com
ping -c 3 drive.google.com

# Test gdown (if installed)
python3 -c "import gdown; print('gdown available')" || pip3 install --user gdown

# Test git access
git ls-remote https://github.com/bluespec/Piccolo.git
```

### **Firewall/Proxy Check**
```bash
# Test HTTPS downloads
curl -I https://github.com
curl -I https://drive.google.com

# Should return: HTTP/2 200 or similar success
```

---

## 📋 tmux Setup Verification

### **tmux Availability**
```bash
# Check tmux installation
which tmux
tmux -V

# Test tmux functionality
tmux new-session -d -s test "echo 'tmux test' && sleep 2"
tmux list-sessions | grep test
tmux kill-session -t test

# Should work without errors
```

### **Session Management Test**
```bash
# Practice tmux workflow
tmux new-session -d -s practice
tmux attach-session -t practice
# Inside tmux: echo "Hello tmux"
# Detach: Ctrl+B, then D
tmux attach-session -t practice
tmux kill-session -t practice
```

---

## 📋 Assignment Component Tests

### **Script Syntax Check**
```bash
# Verify all scripts are valid
cd ~/programming1

bash -n setup_environment.sh
bash -n run_rtl_simulations.sh  
bash -n run_gem5_simulations.sh
bash -n run_alu_tests.sh
bash -n run_complete_assignment.sh

# Should return no errors
```

### **Python Script Check**
```bash
# Verify Python scripts
python3 -m py_compile analyze_results.py
python3 -m py_compile enhanced_alu_test.py

# Should return no errors
```

### **LaTeX Check (Optional)**
```bash
# If LaTeX available, test compilation
if which pdflatex; then
    pdflatex --version
    # Test basic compilation
    echo '\documentclass{article}\begin{document}Hello\end{document}' > test.tex
    pdflatex test.tex && echo "LaTeX working" || echo "LaTeX issues"
    rm -f test.*
fi
```

---

## 📋 Simulation Prerequisites

### **Build Tools Verification**
```bash
# Essential build tools
which make gcc g++ ar ld
make --version | head -1
gcc --version | head -1

# Python development tools
python3-config --includes 2>/dev/null || echo "python3-dev may be needed"
```

### **Memory and CPU Check**
```bash
# System resources
echo "CPU cores: $(nproc)"
echo "RAM: $(free -h | grep Mem)"
echo "Load average: $(uptime)"

# Minimum requirements:
# CPU: 4+ cores preferred
# RAM: 8GB+ preferred  
# Load: <2.0 preferred
```

---

## 📋 Final Pre-Launch Checklist

### **Critical Verifications**
- [ ] **Correct machine**: On CSELabs (not local machine)
- [ ] **Correct user**: Logged in as hasan181
- [ ] **Correct directory**: In ~/programming1/
- [ ] **Disk space**: >15GB available in scratch
- [ ] **Network**: Can download from GitHub and Google Drive
- [ ] **Tools**: All required tools available and working
- [ ] **Permissions**: All scripts executable
- [ ] **tmux**: Working and tested
- [ ] **Time available**: 8-14 hours for completion

### **Quick Final Test**
```bash
# Ultimate verification command
cd ~/programming1 && \
./preflight_check.sh && \
echo "=== READY TO START ASSIGNMENT ===" || \
echo "=== FIX ISSUES BEFORE STARTING ==="
```

---

## 📋 During Execution Monitoring

### **Progress Verification Points**

**After 30 minutes:**
- [ ] Environment setup completed
- [ ] First processor (Piccolo) started building
- [ ] Log files being created: `ls -la *.txt`

**After 2 hours:**
- [ ] RTL simulations in progress
- [ ] Multiple log entries: `wc -l *.txt`
- [ ] Processes running: `ps aux | grep hasan181`

**After 4 hours:**
- [ ] RTL phase completing
- [ ] GEM5 setup started
- [ ] Scratch directory populated: `ls /export/scratch/users/hasan181/`

**After 8 hours:**
- [ ] GEM5 simulations running
- [ ] Performance data collected
- [ ] ALU tests may have started

---

## 📋 Post-Execution Verification

### **Completion Checklist**
- [ ] All log files present and non-empty
- [ ] Performance plots generated (PNG files)
- [ ] Report PDF updated with real data
- [ ] No error messages in final logs
- [ ] Assignment marked as "Complete"

### **Result Quality Check**
```bash
# Quick result validation
cd ~/programming1

echo "=== Result Verification ==="
echo "RTL results: $(grep -c "cycles/second" rtl_simulation_log.txt || echo 0)"
echo "GEM5 results: $(grep -c "cpi" gem5_simulation_log.txt || echo 0)"  
echo "ALU results: $(grep -c "PASS" alu_test_log.txt || echo 0)"
echo "Plots: $(ls *.png 2>/dev/null | wc -l)"
echo "PDF size: $(du -h report_template.pdf 2>/dev/null || echo "missing")"
```

---

## 🎯 Success Criteria

**Your assignment is successfully verified when:**

✅ **All verification checks pass**  
✅ **No error messages in any check**  
✅ **Sufficient resources available**  
✅ **All tools working correctly**  
✅ **Network connectivity confirmed**  
✅ **tmux functionality tested**  

**You can confidently proceed with execution when this checklist is 100% complete!**

---

## 🆘 If Verification Fails

1. **Review**: Check `TROUBLESHOOTING.md` for specific issues
2. **Fix**: Address any failing checks before proceeding  
3. **Retry**: Re-run verification after fixes
4. **Proceed**: Only start assignment after all checks pass

**Do not skip verification - it prevents 90% of runtime issues! 🚀**