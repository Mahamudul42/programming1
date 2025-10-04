#!/bin/bash

# Master script to run all Programming Assignment 1 components
# Replace <X500> with your actual X500 ID

set -e  # Exit on any error

X500="hasan181"
WORK_DIR="/export/scratch/users/$X500"

echo "=== Programming Assignment 1 - Complete Solution ==="
echo "Student: $X500"
echo "Working Directory: $WORK_DIR"
echo

# Make all scripts executable
chmod +x setup_environment.sh
chmod +x run_rtl_simulations.sh
chmod +x run_gem5_simulations.sh
chmod +x run_alu_tests.sh

echo "1. Setting up environment..."
./setup_environment.sh

echo
echo "2. Running RTL simulations..."
./run_rtl_simulations.sh 2>&1 | tee rtl_simulation_log.txt

echo
echo "3. Running GEM5 simulations..."
./run_gem5_simulations.sh 2>&1 | tee gem5_simulation_log.txt

echo
echo "4. Running ALU tests..."
./run_alu_tests.sh 2>&1 | tee alu_test_log.txt

echo
echo "5. Analyzing results..."
cd "$WORK_DIR"
python3 -c "
import sys
sys.path.append('/data/munna/all/programming1')
import os
os.chdir('$WORK_DIR')
from analyze_results import SimulationAnalyzer
analyzer = SimulationAnalyzer('$WORK_DIR')
analyzer.run_analysis()
" 2>&1 | tee analysis_log.txt

echo
echo "6. Generating report..."
cd /data/munna/all/programming1
if command -v pdflatex &> /dev/null; then
    echo "Creating placeholder performance plots..."
    python3 -c "
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import numpy as np

# Create placeholder performance comparison plot
fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(12, 5))

# RTL Performance plot
processors = ['Piccolo', 'Flute', 'Toooba']
verilator_perf = [1.25e6, 9.8e5, 4.5e5]
bluesim_perf = [8.5e5, 7.2e5, 3.2e5]

x = np.arange(len(processors))
width = 0.35

ax1.bar(x - width/2, verilator_perf, width, label='Verilator', alpha=0.8)
ax1.bar(x + width/2, bluesim_perf, width, label='Bluesim', alpha=0.8)
ax1.set_xlabel('Processor')
ax1.set_ylabel('Cycles/Second')
ax1.set_title('RTL Simulation Performance')
ax1.set_xticks(x)
ax1.set_xticklabels(processors)
ax1.legend()
ax1.grid(True, alpha=0.3)

# GEM5 Performance plot
configs = ['Baseline', 'Small', 'Large']
cpi_values = [1.45, 1.78, 1.28]

ax2.bar(configs, cpi_values, alpha=0.8, color='orange')
ax2.set_xlabel('Configuration')
ax2.set_ylabel('CPI (Cycles Per Instruction)')
ax2.set_title('GEM5 O3 Performance')
ax2.grid(True, alpha=0.3)

plt.tight_layout()
plt.savefig('gem5_performance_comparison.png', dpi=300, bbox_inches='tight')
plt.close()
print('Placeholder plots created')
"
    
    echo "Compiling LaTeX report..."
    pdflatex -interaction=nonstopmode report_template.tex > /dev/null 2>&1
    pdflatex -interaction=nonstopmode report_template.tex > /dev/null 2>&1
    
    if [ -f "report_template.pdf" ]; then
        echo "✓ Report generated: report_template.pdf"
        
        # Clean up LaTeX auxiliary files
        rm -f *.aux *.log *.out *.toc *.lof *.lot 2>/dev/null
    else
        echo "⚠ Failed to generate PDF report"
    fi
else
    echo "LaTeX not available. Please compile report_template.tex manually."
fi

echo
echo "=== Assignment Complete ==="
echo "Results saved in:"
echo "  - RTL logs: rtl_simulation_log.txt"
echo "  - GEM5 logs: gem5_simulation_log.txt"
echo "  - ALU logs: alu_test_log.txt"
echo "  - Analysis: analysis_log.txt"
echo "  - Plots: *.png files"
echo "  - Report template: report_template.tex"
echo
echo "Next steps:"
echo "1. Review all log files for results"
echo "2. Update report_template.tex with your actual results"
echo "3. Add your team member information"
echo "4. Compile and submit the final PDF report"