# 📖 Step-by-Step Execution Guide

## 🎯 Complete Walkthrough for Programming Assignment 1

**Student**: hasan181  
**Teammate**: suh00051  
**Assignment**: CSCI 5204/EE 5364 Programming Assignment 1  
**Due**: October 5, 2025, 11:59pm  

---

## 📋 Pre-Execution Checklist

- [ ] Access to CSELabs machine (Keller 1-250 or SSH)
- [ ] This programming1 folder copied to CSELabs
- [ ] At least 8-14 hours available for execution
- [ ] Stable internet connection for downloads

---

## 🚀 Step 1: Connect to CSELabs

### **Option A: Physical Lab Access**
```bash
# Go to Keller 1-250 and log in directly
# Username: hasan181
# Use your UMN password
```

### **Option B: SSH Access (Recommended)**
```bash
# From your current machine
ssh hasan181@keller-lab.cs.umn.edu
# Or try: ssh hasan181@csel-kh1250-01.cselabs.umn.edu
```

---

## 🚀 Step 2: Transfer Assignment Files

### **From Your Current Machine**
```bash
# Copy entire programming1 folder
scp -r /data/munna/all/programming1 hasan181@keller-lab.cs.umn.edu:~/

# Verify transfer
ssh hasan181@keller-lab.cs.umn.edu "ls -la ~/programming1"
```

### **Alternative: Manual Transfer**
If SCP doesn't work:
1. Compress the folder: `tar -czf programming1.tar.gz programming1/`
2. Use file transfer tools or USB drive
3. Extract on CSELabs: `tar -xzf programming1.tar.gz`

---

## 🚀 Step 3: Verify Setup on CSELabs

```bash
# SSH to CSELabs
ssh hasan181@keller-lab.cs.umn.edu

# Navigate to assignment
cd ~/programming1

# Run preflight check
chmod +x INSTRUCTIONS/QUICK_START.sh
chmod +x preflight_check.sh
./preflight_check.sh
```

**Expected Output:**
```
=== Programming Assignment 1 - Pre-flight Check ===
✓ bash is available
✓ python3 is available  
✓ git is available
✓ make is available
✓ Scratch directory is accessible
✓ Sufficient disk space available
```

---

## 🚀 Step 4: Start Long-Running Assignment

### **Option A: Using tmux (Recommended for Going Home)**

```bash
# Create tmux session
tmux new-session -d -s assignment1

# Attach to session
tmux attach-session -t assignment1

# Start assignment (inside tmux)
cd ~/programming1
./run_complete_assignment.sh

# DETACH SAFELY: Press Ctrl+B, then D
# You can now disconnect and go home!
```

### **Option B: Direct Execution (Stay Connected)**

```bash
# Run directly (must stay connected)
cd ~/programming1
./run_complete_assignment.sh
```

---

## 🚀 Step 5: Monitor Progress (Optional)

### **Check Progress Remotely**
```bash
# SSH back in
ssh hasan181@keller-lab.cs.umn.edu

# Reattach to tmux session
tmux attach-session -t assignment1

# Check current status
tail -f ~/programming1/rtl_simulation_log.txt
```

### **Progress Indicators**
```bash
# Check if processes are running
ps aux | grep -E "(verilator|bluesim|gem5)" | grep hasan181

# Check log file sizes (growing = progress)
ls -lah ~/programming1/*.txt

# Check completion
grep -l "Assignment Complete" ~/programming1/*.txt
```

---

## 🚀 Step 6: Collect Results (After 8-14 Hours)

### **Return and Check Completion**
```bash
# SSH back to CSELabs
ssh hasan181@keller-lab.cs.umn.edu

# Reattach to session
tmux attach-session -t assignment1

# Check if completed
grep "Assignment Complete" ~/programming1/*.txt
```

### **Verify All Results Generated**
```bash
cd ~/programming1

# Check for key result files
ls -la *.txt *.png *.pdf

# Expected files:
# ✓ rtl_simulation_log.txt
# ✓ gem5_simulation_log.txt  
# ✓ alu_test_log.txt
# ✓ analysis_log.txt
# ✓ report_template.pdf
# ✓ gem5_performance_comparison.png
# ✓ rtl_performance_comparison.png
```

---

## 🚀 Step 7: Review and Extract Results

### **Quick Results Summary**
```bash
# View RTL results
echo "=== RTL RESULTS ==="
grep -A 10 "cycles/second" rtl_simulation_log.txt

# View GEM5 results  
echo "=== GEM5 RESULTS ==="
grep -A 5 "cpi\|CPI" gem5_simulation_log.txt

# View ALU results
echo "=== ALU RESULTS ==="
grep -A 5 "PASS\|FAIL" alu_test_log.txt
```

### **Download Results to Your Machine**
```bash
# From your local machine
scp hasan181@keller-lab.cs.umn.edu:~/programming1/*.pdf ./
scp hasan181@keller-lab.cs.umn.edu:~/programming1/*.png ./
scp hasan181@keller-lab.cs.umn.edu:~/programming1/*.txt ./
```

---

## 🚀 Step 8: Final Report Preparation

### **Update Report with Real Data**
1. Open `report_template.tex`
2. Replace placeholder data with actual results from logs
3. Update analysis sections with your findings
4. Recompile PDF: `pdflatex report_template.tex`

### **Submit Final Report**
- Rename to: `5204_Fall2025_ProgrammingAssignment1.pdf`
- Upload to Canvas
- **Only one submission per team!**

---

## ⏱️ Timeline Summary

| Phase | Duration | Your Involvement |
|-------|----------|------------------|
| Setup & Transfer | 30 min | Active |
| RTL Simulations | 2-4 hours | Monitor (optional) |
| GEM5 Simulations | 3-6 hours | Away (tmux) |
| ALU Testing | 15 min | Monitor (optional) |
| Analysis & Report | 10 min | Active |
| **TOTAL** | **6-11 hours** | **1 hour active** |

---

## 🎯 Success Criteria

**You're done when you have:**
- ✅ All log files with simulation results
- ✅ Performance comparison plots
- ✅ Updated PDF report with real data
- ✅ No error messages in logs
- ✅ Assignment marked as "Complete"

---

## 🆘 Need Help?

- Check `TROUBLESHOOTING.md` for common issues
- Review `EXPECTED_RESULTS.md` for sample outputs
- Use `VERIFICATION_CHECKLIST.md` to ensure everything works

**Good luck with your assignment!** 🎓