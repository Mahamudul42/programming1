# 📝 Submission Guide

## 🎯 Final Steps for Assignment Submission

**Due Date**: October 5, 2025, 11:59pm  
**Students**: hasan181 & suh00051  
**Course**: CSCI 5204/EE 5364  

---

## 📋 Pre-Submission Checklist

### **Essential Files Verification**
- [ ] `report_template.pdf` generated with **real experimental data**
- [ ] `rtl_performance_comparison.png` with actual RTL results
- [ ] `gem5_performance_comparison.png` with actual GEM5 results  
- [ ] All log files contain actual simulation data (not placeholders)
- [ ] No error messages in final logs

### **Results Quality Check**
```bash
cd ~/programming1

# Verify real data is present
echo "=== Data Verification ==="
echo "RTL entries: $(grep -c "cycles/second" rtl_simulation_log.txt)"
echo "GEM5 entries: $(grep -c "cpi" gem5_simulation_log.txt)"
echo "ALU tests: $(grep -c "PASS" alu_test_log.txt)"
echo "Completion: $(grep -c "Assignment Complete" *.txt)"

# Should show non-zero counts for all
```

---

## 📊 Report Customization

### **Step 1: Update Report with Real Data**

```bash
# Extract your actual results
cd ~/programming1

# Get RTL performance data
echo "=== RTL RESULTS ==="
grep -A 10 "cycles/second" rtl_simulation_log.txt > rtl_summary.txt

# Get GEM5 performance data  
echo "=== GEM5 RESULTS ==="
grep -A 5 "cpi" gem5_simulation_log.txt > gem5_summary.txt

# Get ALU test results
echo "=== ALU RESULTS ==="
grep -A 10 "PASS\|FAIL" alu_test_log.txt > alu_summary.txt
```

### **Step 2: Replace Placeholder Data in LaTeX**

Edit `report_template.tex` with your actual results:

```latex
% Replace the example table data:
\begin{table}[h]
\centering
\caption{RTL Simulation Performance Results}
\label{tab:rtl_results}
\begin{tabular}{@{}lccc@{}}
\toprule
Processor & Verilator (cycles/s) & Bluesim (cycles/s) & Speed Ratio \\
\midrule
% UPDATE THESE WITH YOUR ACTUAL RESULTS:
Piccolo (RV32)   & YOUR_VERILATOR_DATA & YOUR_BLUESIM_DATA & YOUR_RATIO \\
Flute (RV64)     & YOUR_VERILATOR_DATA & YOUR_BLUESIM_DATA & YOUR_RATIO \\
Toooba (RV64 OoO) & YOUR_VERILATOR_DATA & YOUR_BLUESIM_DATA & YOUR_RATIO \\
\bottomrule
\end{tabular}
\end{table}
```

### **Step 3: Add Your Analysis**

Replace the placeholder analysis with your findings:

```latex
\textbf{Performance Trends:} Based on our experimental results...

\textbf{Simulator Comparison:} We observed that Verilator achieved...

\textbf{Architecture Impact:} The out-of-order Toooba processor showed...
```

---

## 📄 Final PDF Generation

### **Method 1: Automated PDF Update**
```bash
cd ~/programming1

# Generate final PDF with real plots
./generate_pdf.sh

# This creates updated report_template.pdf
```

### **Method 2: Manual LaTeX Compilation**
```bash
# After editing report_template.tex
pdflatex report_template.tex
pdflatex report_template.tex  # Run twice for references

# Check PDF was created
ls -la report_template.pdf
```

### **Method 3: With Updated Plots**
```bash
# Generate fresh plots with your data
python3 analyze_results.py

# Compile report with new plots
pdflatex report_template.tex
pdflatex report_template.tex
```

---

## 📤 File Preparation for Submission

### **Step 1: Rename Final Report**
```bash
# Rename to required submission format
cp report_template.pdf 5204_Fall2025_ProgrammingAssignment1.pdf

# Verify the file
ls -la 5204_Fall2025_ProgrammingAssignment1.pdf
```

### **Step 2: Download Files from CSELabs**
```bash
# From your local machine, download final files
scp hasan181@keller-lab.cs.umn.edu:~/programming1/5204_Fall2025_ProgrammingAssignment1.pdf ./
scp hasan181@keller-lab.cs.umn.edu:~/programming1/*.png ./
scp hasan181@keller-lab.cs.umn.edu:~/programming1/*.txt ./

# Optional: Download everything as backup
scp -r hasan181@keller-lab.cs.umn.edu:~/programming1/ ./assignment_backup/
```

### **Step 3: Final File Verification**
```bash
# Check submission file
file 5204_Fall2025_ProgrammingAssignment1.pdf
# Should show: PDF document

# Check file size (should be >100KB with real data)
du -h 5204_Fall2025_ProgrammingAssignment1.pdf

# Quick content check
pdfinfo 5204_Fall2025_ProgrammingAssignment1.pdf
# Should show: Pages: 4+ (or appropriate page count)
```

---

## 📋 Report Content Requirements

### **Must Include (Grade Impact)**

**Team Information (Required):**
- ✅ Names: Hasan & Teammate  
- ✅ Emails: hasan181@umn.edu & suh00051@umn.edu
- ✅ X500s: hasan181 & suh00051

**RTL Results (50 points):**
- ✅ Cycles/second for all 6 combinations (3 processors × 2 simulators)
- ✅ Performance comparison table
- ✅ Analysis of simulator speed differences
- ✅ Hypothesis about performance trends

**GEM5 Results (40 points):**
- ✅ CPI data for all 4 O3 configurations
- ✅ Performance plots showing configuration impact
- ✅ hostTickRate comparison with RTL simulation
- ✅ Analysis of architectural parameter effects

**ALU Testing (10 points):**
- ✅ Pass/fail results for all test categories
- ✅ Documentation of any bugs found (if any)
- ✅ Proposed fixes for bugs (if applicable)

**Analysis Quality:**
- ✅ Clear explanations of performance trends
- ✅ Hypotheses about observed behavior
- ✅ Professional plots with labeled axes
- ✅ Concise writing (<2000 words preferred)

---

## 📈 Report Quality Enhancement

### **Professional Formatting**
```latex
% Ensure professional appearance:
% - Clear section headings
% - Numbered figures and tables
% - Proper citations (if external sources used)
% - Consistent formatting
% - No spelling/grammar errors
```

### **Data Presentation Best Practices**
- **Tables**: Include units (cycles/second, CPI, etc.)
- **Plots**: Clear axis labels, legends, titles
- **Numbers**: Use appropriate precision (3-4 significant figures)
- **Trends**: Explain increases/decreases clearly

### **Analysis Depth**
```
Strong Analysis Example:
"Verilator achieves 1.4x higher performance than Bluesim because 
it compiles Verilog to optimized C++ code, while Bluesim uses 
interpreted simulation. This compilation overhead is offset by 
faster runtime execution for long simulations."

Weak Analysis:
"Verilator is faster than Bluesim."
```

---

## 📤 Canvas Submission Process

### **Before Submission**
- [ ] **Team Coordination**: Ensure only ONE team member submits
- [ ] **File Name**: Must be `5204_Fall2025_ProgrammingAssignment1.pdf`
- [ ] **File Size**: Check it's reasonable (100KB - 10MB)
- [ ] **Team Info**: Verify both team members listed in PDF

### **Submission Steps**
1. **Log into Canvas**
2. **Navigate to Assignment**: CSCI 5204 → Assignments → Programming Assignment 1
3. **Upload File**: `5204_Fall2025_ProgrammingAssignment1.pdf`
4. **Add Comments**: Include team member information if required
5. **Submit**: Click submit button
6. **Verify**: Check submission confirmation

### **Post-Submission**
- [ ] **Confirmation**: Save submission confirmation email
- [ ] **Team Notification**: Inform teammate about submission
- [ ] **Backup**: Keep local copies of all files

---

## 🎯 Grading Expectations

### **Point Distribution**
- **RTL Simulation (50 pts)**: Complete performance data and analysis
- **GEM5 Simulation (40 pts)**: Configuration study with plots
- **ALU Testing (10 pts)**: Test results and bug documentation

### **Common Point Deductions**
- ❌ **Missing team member info**: -5 points
- ❌ **Placeholder data**: -20 points per section
- ❌ **No analysis/explanation**: -10 points per section
- ❌ **Poor formatting**: -5 points
- ❌ **Late submission**: Per course policy

### **Bonus Opportunities**
- ✅ **Exceptional analysis**: Deep insights into performance trends
- ✅ **Additional experiments**: Beyond minimum requirements
- ✅ **Professional presentation**: Publication-quality plots and writing

---

## ✅ Final Submission Checklist

**Before clicking "Submit":**

- [ ] **Correct filename**: `5204_Fall2025_ProgrammingAssignment1.pdf`
- [ ] **Team information**: Both hasan181 and suh00051 listed
- [ ] **Real data**: No placeholder values in results
- [ ] **Complete analysis**: All sections have explanations
- [ ] **Professional quality**: Clean formatting, labeled plots
- [ ] **Page count**: Reasonable length (4-8 pages typical)
- [ ] **File integrity**: PDF opens correctly
- [ ] **One submission**: Only one team member submits
- [ ] **On time**: Submitted before October 5, 2025, 11:59pm

---

## 🎉 Post-Submission

**Congratulations! You've completed a comprehensive microarchitecture simulation study!**

**What you accomplished:**
- ✅ Built and tested 3 RISC-V processors
- ✅ Compared RTL simulation performance  
- ✅ Analyzed out-of-order processor configurations
- ✅ Validated ALU implementations
- ✅ Generated professional research-quality results

**Skills gained:**
- Microarchitecture simulation
- Performance analysis
- Hardware testing methodologies  
- Technical report writing
- Linux/Unix system administration

**Good luck with your grades! 🚀**