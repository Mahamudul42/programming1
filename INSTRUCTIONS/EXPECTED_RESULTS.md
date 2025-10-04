# 📊 Expected Results Guide

## 🎯 What to Expect After Running the Assignment

This guide shows you **exactly what outputs** you should see after successfully running the Programming Assignment 1 on CSELabs.

---

## 📁 Generated Files Overview

After completion, your `~/programming1/` directory should contain:

```
programming1/
├── 📈 rtl_simulation_log.txt           # RTL simulation results
├── 📈 gem5_simulation_log.txt          # GEM5 benchmark results
├── 📈 alu_test_log.txt                 # ALU testing results
├── 📈 analysis_log.txt                 # Automated analysis
├── 📊 gem5_performance_comparison.png   # GEM5 plots
├── 📊 rtl_performance_comparison.png    # RTL plots
├── 📄 report_template.pdf              # Updated report
└── 📋 Multiple processor build directories in scratch
```

---

## 📊 Expected RTL Simulation Results

### **rtl_simulation_log.txt Sample Content:**

```
=== Building and Testing RTL Processors ===
Working in: /export/scratch/users/hasan181

1. Setting up Piccolo...
✓ Piccolo cloned and patched successfully

Building Piccolo with Verilator...
Execution time: 1847.3 seconds
Running Piccolo tests...
Execution time: 423.7 seconds
Execution time: 2156.8 seconds

Piccolo Verilator Results:
Logs/rv32ui-p-add.log:Simulation speed: 1,247,382 cycles/second
Logs/rv32ui-p-sub.log:Simulation speed: 1,251,456 cycles/second
Logs/rv32ui-p-and.log:Simulation speed: 1,239,847 cycles/second

Building Piccolo with Bluesim...
Execution time: 892.4 seconds
Execution time: 398.2 seconds
Execution time: 2089.7 seconds

Piccolo Bluesim Results:
Logs/rv32ui-p-add.log:Simulation speed: 856,294 cycles/second
Logs/rv32ui-p-sub.log:Simulation speed: 863,157 cycles/second
Logs/rv32ui-p-and.log:Simulation speed: 849,582 cycles/second

... (similar for Flute and Toooba)

SUMMARY:
========
Piccolo  - Verilator: ~1.25M cycles/sec, Bluesim: ~856K cycles/sec
Flute    - Verilator: ~982K cycles/sec, Bluesim: ~724K cycles/sec  
Toooba   - Verilator: ~451K cycles/sec, Bluesim: ~319K cycles/sec
```

### **Expected Performance Ranges:**

| Processor | Verilator (cycles/sec) | Bluesim (cycles/sec) | Ratio |
|-----------|------------------------|----------------------|-------|
| Piccolo   | 1.0M - 1.5M           | 700K - 900K          | 1.3-1.6x |
| Flute     | 800K - 1.2M           | 600K - 800K          | 1.2-1.5x |
| Toooba    | 350K - 600K           | 250K - 400K          | 1.3-1.7x |

---

## 📊 Expected GEM5 Simulation Results

### **gem5_simulation_log.txt Sample Content:**

```
=== Setting up GEM5 with PARSEC ===
Working in: /export/scratch/users/hasan181

Cloning and building GEM5...
Build completed in 3247 seconds

Running simulation with configuration: baseline
=== Results for baseline - blackscholes_simulation ===
CPI:
system.cpu.cpi                              1.453791
Host Tick Rate:
system.cpu.tickrate                         2.147e+09

Running simulation with configuration: LQ16_SQ16_IW4_ROB128
=== Results for LQ16_SQ16_IW4_ROB128 - blackscholes_simulation ===
CPI:
system.cpu.cpi                              1.782456
Host Tick Rate:
system.cpu.tickrate                         2.298e+09

Running simulation with configuration: LQ64_SQ64_IW12_ROB384
=== Results for LQ64_SQ64_IW12_ROB384 - blackscholes_simulation ===
CPI:
system.cpu.cpi                              1.287394
Host Tick Rate:
system.cpu.tickrate                         1.847e+09

SUMMARY:
========
Baseline  (32/32/8/192):  CPI=1.45, HostTickRate=2.15e9
Small     (16/16/4/128):  CPI=1.78, HostTickRate=2.30e9
Large     (64/64/12/384): CPI=1.29, HostTickRate=1.85e9
```

### **Expected CPI Ranges:**

| Configuration | Expected CPI | Host Tick Rate | Performance |
|---------------|--------------|----------------|-------------|
| Baseline      | 1.40 - 1.50  | 2.0e9 - 2.3e9 | Good        |
| Small         | 1.70 - 1.85  | 2.2e9 - 2.5e9 | Slower      |
| Large         | 1.20 - 1.35  | 1.7e9 - 2.0e9 | Faster      |
| Mixed         | 1.50 - 1.60  | 1.9e9 - 2.2e9 | Medium      |

---

## 📊 Expected ALU Test Results

### **alu_test_log.txt Sample Content:**

```
=== Setting up ALU Tests with COCOTB ===
Working in: /export/scratch/users/hasan181/HW-cocotb-alu

Creating Python virtual environment...
Installing COCOTB and dependencies...
Successfully installed cocotb-1.8.1 cocotb-coverage-1.1.0

Running ALU tests...
make SIM=icarus

MODULE=test_alu TOPLEVEL=alu TOPLEVEL_LANG=verilog \
python -m pytest test_alu.py -v

================= test session starts =================
platform linux -- Python 3.10.12, pytest-7.4.3
cachedir: .pytest_cache
rootdir: /export/scratch/users/hasan181/HW-cocotb-alu/sim

test_alu.py::test_alu_add PASSED                [  12%]
test_alu.py::test_alu_sub PASSED                [  25%]
test_alu.py::test_alu_and PASSED                [  37%]
test_alu.py::test_alu_or PASSED                 [  50%]
test_alu.py::test_alu_xor PASSED                [  62%]
test_alu.py::test_alu_shift_left PASSED         [  75%]
test_alu.py::test_alu_shift_right_logical PASSED [  87%]
test_alu.py::test_alu_comprehensive PASSED      [ 100%]

=================== 8 passed in 12.47s ===================

=== ALU Test Results ===
TOTAL TESTS RUN: 116
PASSED: 116
FAILED: 0

Test Categories:
- Basic Operations (8 tests): ALL PASSED
- Edge Cases (5 tests): ALL PASSED  
- Random Tests (100 tests): ALL PASSED
- Overflow Tests (3 tests): ALL PASSED

STATUS: ALL TESTS PASSED - NO BUGS DETECTED
```

### **Expected Test Outcomes:**

| Test Category | Expected Count | Expected Result |
|---------------|----------------|-----------------|
| Basic Operations | 8 tests | ALL PASS |
| Edge Cases | 5 tests | ALL PASS |
| Random Tests | 100 tests | ALL PASS |
| Overflow Tests | 3 tests | ALL PASS |
| **TOTAL** | **116 tests** | **ALL PASS** |

---

## 📈 Expected Performance Plots

### **rtl_performance_comparison.png:**
- **Type**: Bar chart with two sets of bars
- **X-axis**: Processors (Piccolo, Flute, Toooba)
- **Y-axis**: Cycles per second
- **Data**: Verilator vs Bluesim performance
- **Trend**: Verilator consistently faster

### **gem5_performance_comparison.png:**
- **Type**: Dual subplot figure
- **Left Plot**: RTL performance comparison
- **Right Plot**: GEM5 CPI vs configuration
- **Trend**: Large config has lowest CPI

---

## 📄 Expected Report Content

### **report_template.pdf Updates:**
The PDF should be updated with **real data** replacing placeholders:

```latex
% OLD (placeholder):
Piccolo (RV32)   & 1.25e6 & 8.50e5 & 1.47 \\

% NEW (actual results):
Piccolo (RV32)   & 1.247e6 & 8.56e5 & 1.46 \\
```

---

## ⏱️ Expected Timing

### **Phase Durations:**

| Phase | Expected Duration | Progress Indicators |
|-------|------------------|-------------------|
| Environment Setup | 30-60 min | Tool downloads, builds |
| Piccolo RTL | 45-90 min | Verilator + Bluesim builds |
| Flute RTL | 45-90 min | Both simulator tests |
| Toooba RTL | 60-120 min | Complex OoO processor |
| GEM5 Setup | 60-90 min | Large codebase build |
| GEM5 Simulations | 2-4 hours | Multiple configurations |
| ALU Tests | 10-15 min | Fast COCOTB execution |
| Analysis | 5-10 min | Plot generation |

### **Total Expected Time: 6-11 hours**

---

## 🔍 Progress Monitoring

### **How to Check Progress:**

```bash
# Check running processes
ps aux | grep -E "(verilator|bluesim|gem5)" | grep hasan181

# Monitor log file growth
watch -n 30 'wc -l *.txt'

# Check latest activity
tail -f rtl_simulation_log.txt
tail -f gem5_simulation_log.txt

# Look for completion markers
grep -l "Assignment Complete" *.txt
grep -l "All tests passed" *.txt
```

### **Success Indicators:**

```bash
✅ rtl_simulation_log.txt contains "cycles/second" for all processors
✅ gem5_simulation_log.txt contains CPI values for all configurations  
✅ alu_test_log.txt shows "ALL TESTS PASSED"
✅ analysis_log.txt contains "Analysis complete"
✅ PNG files generated with actual plots
✅ report_template.pdf updated with real data
```

---

## ❌ Red Flags (Things to Watch For)

### **Potential Issues:**

```bash
❌ "No space left on device" - Disk full
❌ "Permission denied" - File permission issues
❌ "make: *** Error" - Compilation failures
❌ "Connection timed out" - Network issues
❌ "Segmentation fault" - Runtime crashes
❌ Log files not growing for >30 minutes
```

### **Recovery Actions:**

```bash
# Disk space issue
df -h && du -sh /export/scratch/users/hasan181/*
rm -rf /export/scratch/users/hasan181/*/build/temp

# Permission issue  
chmod +x ~/programming1/*.sh

# Network issue
ping github.com && curl -I https://drive.google.com

# Compilation issue
make clean && make -j4  # Reduce parallel jobs
```

---

## 🎯 Final Validation Checklist

**Your assignment is successful when you have:**

- [ ] **RTL Results**: Performance data for all 6 combinations (3 processors × 2 simulators)
- [ ] **GEM5 Results**: CPI data for all 4 O3 configurations  
- [ ] **ALU Results**: 116/116 tests passed
- [ ] **Performance Plots**: Two PNG files with actual data
- [ ] **Updated Report**: PDF with real experimental results
- [ ] **No Error Messages**: Clean completion logs
- [ ] **Reasonable Values**: Results within expected ranges

**If you have all these, you're ready to submit! 🎉**