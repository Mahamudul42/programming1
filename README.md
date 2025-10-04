# Programming Assignment 1 - Solution Guide

This directory contains a complete solution framework for CSCI 5204/EE 5364 Programming Assignment 1: Microarchitecture Simulation and Testing.

## Quick Start

1. **IDs already updated**: Scripts are configured for hasan181 and suh00051
2. **Run Complete Assignment**: 
   ```bash
   chmod +x run_complete_assignment.sh
   ./run_complete_assignment.sh
   ```

## Files Overview

### Scripts
- `setup_environment.sh` - Sets up tools and downloads required files
- `run_rtl_simulations.sh` - Builds and tests Piccolo, Flute, and Toooba
- `run_gem5_simulations.sh` - Runs GEM5 O3 simulations with PARSEC
- `run_alu_tests.sh` - Tests ALU using COCOTB framework
- `run_complete_assignment.sh` - Master script that runs everything

### Analysis Tools
- `analyze_results.py` - Python script to parse results and generate plots
- `enhanced_alu_test.py` - Comprehensive ALU test cases for COCOTB

### Documentation
- `report_template.tex` - LaTeX template for the final report
- `README.md` - This file

## Assignment Components

### 1. RTL Simulation (50 points)
**Task**: Compare Verilator vs Bluesim performance for three RISC-V processors

**Processors**:
- Piccolo (RV32 in-order)
- Flute (RV64 in-order) 
- Toooba (RV64 out-of-order)

**Expected Results**:
- Cycles/second measurements for each processor/simulator combination
- Performance comparison and analysis
- Hypothesis about simulator speed differences

### 2. Event-driven Simulation (40 points)
**Task**: Use GEM5 O3 CPU with PARSEC benchmarks

**Configurations to Test**:
- LQ/SQ Entries: 16, 32, 64
- Issue Width: 4, 8, 12
- ROB Entries: 128, 192, 384

**Expected Results**:
- CPI plots for different configurations
- hostTickRate measurements
- Performance trend analysis

### 3. Hardware Testing (10 points)
**Task**: Test ALU implementation using COCOTB

**Test Coverage**:
- Basic arithmetic operations (ADD, SUB)
- Logical operations (AND, OR, XOR)
- Shift operations (SLL, SRL, SRA)
- Edge cases and random testing

**Expected Results**:
- Pass/fail status for all tests
- Bug reports (if any) with proposed fixes

## Detailed Instructions

### Prerequisites
- Access to CSELabs machines
- Basic knowledge of bash, Python, and simulation tools
- Sufficient scratch space (~10GB)

### Step-by-Step Execution

1. **Environment Setup**:
   ```bash
   # Update X500 in all scripts
   sed -i 's/your_x500_id/your_actual_x500/g' *.sh *.py
   
   # Run setup
   ./setup_environment.sh
   ```

2. **RTL Simulations**:
   ```bash
   ./run_rtl_simulations.sh
   ```
   This will:
   - Clone and patch processor repositories
   - Build with both Verilator and Bluesim
   - Run ISA tests and measure performance

3. **GEM5 Simulations**:
   ```bash
   ./run_gem5_simulations.sh
   ```
   This will:
   - Set up PARSEC benchmarks
   - Build GEM5 with X86 MESI configuration
   - Test different O3 configurations
   - Collect CPI and hostTickRate data

4. **ALU Testing**:
   ```bash
   ./run_alu_tests.sh
   ```
   This will:
   - Set up Python virtual environment
   - Install COCOTB and dependencies
   - Run comprehensive ALU tests

5. **Results Analysis**:
   ```bash
   python3 analyze_results.py
   ```
   This will:
   - Parse all simulation logs
   - Generate performance plots
   - Create summary tables

### Expected Timeline
- Environment setup: 30 minutes
- RTL simulations: 2-4 hours
- GEM5 simulations: 3-6 hours  
- ALU testing: 15 minutes
- Analysis and report: 2-3 hours

**Total: 8-14 hours**

## Troubleshooting

### Common Issues

1. **Disk Space**: Use scratch directory, clean up regularly
2. **Compilation Errors**: Check tool versions and paths
3. **Permission Issues**: Ensure scripts are executable
4. **Memory Issues**: Use fewer parallel jobs (-j4 instead of -j8)

### Debug Commands
```bash
# Check available space
df -h /export/scratch/users/$X500

# Monitor compilation
tail -f rtl_simulation_log.txt

# Check process status
ps aux | grep $USER

# Clean up if needed
make clean
```

## Report Generation

The `report_template.tex` provides a complete LaTeX template with:
- Proper formatting and structure
- Placeholder sections for results
- Example tables and figures
- Analysis guidelines

### To Complete Report:
1. Fill in actual team member information
2. Replace placeholder data with real results
3. Add generated plots (PNG files)
4. Write analysis and conclusions
5. Compile with `pdflatex report_template.tex`

## Tips for Success

1. **Start Early**: Allow extra time for compilation and debugging
2. **Monitor Resources**: Keep track of disk space and CPU usage
3. **Save Results**: Copy important logs to home directory
4. **Document Issues**: Note any problems for the report
5. **Work Incrementally**: Test each component before moving on

## Expected Deliverables

Final submission should include:
- PDF report named `5204_Fall2025_ProgrammingAssignment1.pdf`
- Performance comparison plots
- Complete experimental results
- Analysis of performance trends
- Clear documentation of any issues encountered

## Grading Criteria

- **Experimental Results (50%)**: Correct execution and data collection
- **Analysis Quality (40%)**: Depth of performance analysis and insights
- **Report Clarity (10%)**: Organization, presentation, and completeness

Good luck with your assignment!# programming1
