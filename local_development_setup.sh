#!/bin/bash

# Programming Assignment 1 - Local Development Version
# This version works from your current directory when scratch is not available

X500="hasan181"
CURRENT_DIR="/data/munna/all/programming1"
WORK_DIR="$CURRENT_DIR/workspace"

echo "=== Programming Assignment 1 - Local Development Setup ==="
echo "Student: $X500"
echo "Teammate: suh00051"
echo "Working Directory: $WORK_DIR"
echo

# Create local workspace
mkdir -p "$WORK_DIR"
cd "$WORK_DIR" || { echo "Failed to create workspace"; exit 1; }

echo "1. Setting up local environment..."
# Install gdown if not available
if ! command -v gdown &> /dev/null; then
    pip install gdown --user
    export PATH="$HOME/.local/bin:$PATH"
fi

echo "✓ Local workspace created: $WORK_DIR"

echo
echo "2. Note: This is a LOCAL DEVELOPMENT version"
echo "   For the actual assignment on CSELabs:"
echo "   - Log into a CSELabs machine (Keller 1-250)"
echo "   - Use the original scripts with scratch directory"
echo "   - Run: ./run_complete_assignment.sh"
echo

echo "3. For demonstration purposes, we'll simulate the workflow..."

# Create dummy directory structure to show the process
mkdir -p Piccolo/builds/RV32ACIMU_Piccolo_verilator/Logs
mkdir -p Flute/builds/Flute_RV64GC_MSU_WB_L1_L2_verilator_tohost/Logs
mkdir -p Toooba/builds/RV64ACDFIMSU_Toooba_verilator/Logs
mkdir -p gem5_results
mkdir -p alu_results

# Create sample log files
echo "Simulation completed: 1250000 cycles/second" > Piccolo/builds/RV32ACIMU_Piccolo_verilator/Logs/sample.log
echo "Simulation completed: 980000 cycles/second" > Flute/builds/Flute_RV64GC_MSU_WB_L1_L2_verilator_tohost/Logs/sample.log
echo "Simulation completed: 450000 cycles/second" > Toooba/builds/RV64ACDFIMSU_Toooba_verilator/Logs/sample.log

echo "✓ Created sample directory structure"

echo
echo "4. Testing analysis script..."
cd "$CURRENT_DIR"
python3 -c "
import sys
sys.path.append('.')
import os
os.chdir('$WORK_DIR')
from analyze_results import SimulationAnalyzer
analyzer = SimulationAnalyzer('$WORK_DIR')
analyzer.run_analysis()
print('Analysis test completed')
"

echo
echo "5. Creating submission template..."
cd "$CURRENT_DIR"

# Create a sample submission checklist
cat > submission_checklist.md << 'EOF'
# Programming Assignment 1 - Submission Checklist

## Team Information
- **Student 1**: Hasan (hasan181@umn.edu, hasan181)
- **Student 2**: Teammate Name (suh00051@umn.edu, suh00051)

## Pre-submission Checklist

### 1. Environment Setup ✓
- [ ] Logged into CSELabs machine
- [ ] Created scratch directory workspace
- [ ] Downloaded and extracted handout
- [ ] Verified all tools are available

### 2. RTL Simulations (50 points)
- [ ] Built Piccolo with Verilator and Bluesim
- [ ] Built Flute with Verilator and Bluesim  
- [ ] Built Toooba with Verilator and Bluesim
- [ ] Collected cycles/second measurements
- [ ] Compared simulator performance
- [ ] Analyzed performance differences

### 3. GEM5 Simulations (40 points)
- [ ] Set up GEM5 with PARSEC benchmarks
- [ ] Tested baseline O3 configuration
- [ ] Tested small configuration (LQ:16, SQ:16, IW:4, ROB:128)
- [ ] Tested large configuration (LQ:64, SQ:64, IW:12, ROB:384)
- [ ] Collected CPI and hostTickRate data
- [ ] Generated performance plots
- [ ] Analyzed performance trends

### 4. ALU Testing (10 points)
- [ ] Set up COCOTB testing environment
- [ ] Ran comprehensive ALU tests
- [ ] Documented test results (PASS/FAIL)
- [ ] Identified any bugs (if present)
- [ ] Proposed bug fixes (if needed)

### 5. Report and Analysis
- [ ] Generated performance comparison plots
- [ ] Created summary tables
- [ ] Wrote performance analysis
- [ ] Explained simulation differences
- [ ] Hypothesized about performance trends
- [ ] Formatted report professionally

### 6. Final Deliverable
- [ ] Report named: 5204_Fall2025_ProgrammingAssignment1.pdf
- [ ] Report includes all team member information
- [ ] Report is under 2000 words
- [ ] All plots are clearly labeled
- [ ] All experimental results included
- [ ] Clear explanations provided

## Expected Results Summary

### RTL Performance (cycles/second)
| Processor | Verilator | Bluesim | Ratio |
|-----------|-----------|---------|-------|
| Piccolo   | ~1.25e6   | ~8.5e5  | 1.47  |
| Flute     | ~9.8e5    | ~7.2e5  | 1.36  |
| Toooba    | ~4.5e5    | ~3.2e5  | 1.41  |

### GEM5 Performance Trends
- **Large config**: Best CPI (~1.28)
- **Small config**: Worst CPI (~1.78)
- **Issue width**: Higher = better ILP
- **ROB size**: Larger = better performance

### ALU Testing
- **Expected**: All tests PASS
- **Coverage**: Arithmetic, logical, shift operations
- **Edge cases**: Zero inputs, overflow conditions

## Time Estimates
- Setup: 30 minutes
- RTL sims: 2-4 hours
- GEM5 sims: 3-6 hours
- ALU tests: 15 minutes
- Analysis: 2-3 hours
- **Total**: 8-14 hours

## Common Issues and Solutions

1. **Disk Space**: Monitor scratch usage, clean regularly
2. **Compilation Errors**: Check tool versions and paths
3. **Memory Issues**: Reduce parallel jobs (-j4 vs -j8)
4. **Network Issues**: Retry downloads if failed
5. **Simulation Hangs**: Check for infinite loops, kill and restart

## Final Notes
- Save all logs and results
- Backup important data to home directory
- Test report compilation before submission
- Submit only one PDF per team
EOF

echo "✓ Created submission checklist"

echo
echo "=== Local Development Setup Complete ==="
echo
echo "Next steps for actual assignment:"
echo "1. Access CSELabs machine (ssh to Keller lab)"
echo "2. Copy these scripts to your scratch directory"
echo "3. Run: ./run_complete_assignment.sh"
echo "4. Monitor progress and disk space"
echo "5. Use submission_checklist.md to track progress"
echo
echo "Files ready for CSELabs deployment:"
ls -la "$CURRENT_DIR"/*.sh "$CURRENT_DIR"/*.py "$CURRENT_DIR"/*.tex
echo
echo "Good luck with your assignment!"