#!/bin/bash

# Generate PDF report from LaTeX template
# This script creates placeholder plots and compiles the report

echo "=== PDF Report Generation ==="
echo "Student: hasan181"
echo "Teammate: suh00051"
echo

# Create placeholder performance plots
echo "1. Creating performance plots..."
python3 -c "
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import numpy as np

# Create RTL Performance comparison plot
fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(15, 6))

# RTL Performance plot
processors = ['Piccolo', 'Flute', 'Toooba']
verilator_perf = [1.25e6, 9.8e5, 4.5e5]
bluesim_perf = [8.5e5, 7.2e5, 3.2e5]

x = np.arange(len(processors))
width = 0.35

bars1 = ax1.bar(x - width/2, verilator_perf, width, label='Verilator', alpha=0.8, color='steelblue')
bars2 = ax1.bar(x + width/2, bluesim_perf, width, label='Bluesim', alpha=0.8, color='orange')

ax1.set_xlabel('Processor')
ax1.set_ylabel('Cycles/Second')
ax1.set_title('RTL Simulation Performance Comparison')
ax1.set_xticks(x)
ax1.set_xticklabels(processors)
ax1.legend()
ax1.grid(True, alpha=0.3)

# Add value labels on bars
for bar in bars1:
    height = bar.get_height()
    ax1.text(bar.get_x() + bar.get_width()/2., height + 20000, f'{height:.1e}',
             ha='center', va='bottom', fontsize=9)
for bar in bars2:
    height = bar.get_height()
    ax1.text(bar.get_x() + bar.get_width()/2., height + 20000, f'{height:.1e}',
             ha='center', va='bottom', fontsize=9)

# GEM5 Performance plot
configs = ['Baseline\n(32/32/8/192)', 'Small\n(16/16/4/128)', 'Large\n(64/64/12/384)']
cpi_values = [1.45, 1.78, 1.28]

bars3 = ax2.bar(configs, cpi_values, alpha=0.8, color=['green', 'red', 'blue'])
ax2.set_xlabel('Configuration\n(LQ/SQ/IssueWidth/ROB)')
ax2.set_ylabel('CPI (Cycles Per Instruction)')
ax2.set_title('GEM5 O3 Performance vs Configuration')
ax2.grid(True, alpha=0.3)

# Add value labels
for bar, value in zip(bars3, cpi_values):
    height = bar.get_height()
    ax2.text(bar.get_x() + bar.get_width()/2., height + 0.02, f'{value:.2f}',
             ha='center', va='bottom', fontweight='bold')

plt.tight_layout()
plt.savefig('gem5_performance_comparison.png', dpi=300, bbox_inches='tight')
plt.close()
print('✓ Performance plots created')

# Create RTL comparison plot
fig, ax = plt.subplots(figsize=(10, 6))
ratios = [v/b for v, b in zip(verilator_perf, bluesim_perf)]
bars = ax.bar(processors, ratios, alpha=0.8, color='purple')
ax.axhline(y=1, color='red', linestyle='--', alpha=0.7, label='Equal Performance')
ax.set_xlabel('Processor')
ax.set_ylabel('Verilator/Bluesim Speed Ratio')
ax.set_title('Simulator Speed Comparison')
ax.legend()
ax.grid(True, alpha=0.3)

for bar, ratio in zip(bars, ratios):
    height = bar.get_height()
    ax.text(bar.get_x() + bar.get_width()/2., height + 0.02, f'{ratio:.2f}x',
             ha='center', va='bottom', fontweight='bold')

plt.tight_layout()
plt.savefig('rtl_performance_comparison.png', dpi=300, bbox_inches='tight')
plt.close()
print('✓ RTL comparison plot created')
"

if [ $? -eq 0 ]; then
    echo "✓ Plots generated successfully"
else
    echo "⚠ Warning: Plot generation failed"
fi

# Compile LaTeX to PDF
echo
echo "2. Compiling LaTeX report..."
if command -v pdflatex &> /dev/null; then
    echo "Running pdflatex (pass 1)..."
    pdflatex -interaction=nonstopmode report_template.tex > latex_compile.log 2>&1
    
    echo "Running pdflatex (pass 2 - resolving references)..."
    pdflatex -interaction=nonstopmode report_template.tex >> latex_compile.log 2>&1
    
    if [ -f "report_template.pdf" ]; then
        echo "✓ PDF report generated successfully: report_template.pdf"
        echo "  Size: $(du -h report_template.pdf | cut -f1)"
        echo "  Pages: $(pdfinfo report_template.pdf 2>/dev/null | grep Pages | awk '{print $2}' || echo 'unknown')"
        
        # Clean up auxiliary files
        rm -f *.aux *.log *.out *.toc *.lof *.lot 2>/dev/null
        echo "✓ Cleaned up temporary files"
    else
        echo "✗ Failed to generate PDF"
        echo "Check latex_compile.log for errors"
    fi
else
    echo "✗ pdflatex not found"
    echo "Please install LaTeX: sudo apt-get install texlive-latex-extra"
fi

echo
echo "3. Generated files:"
ls -la *.pdf *.png 2>/dev/null | while read line; do echo "  $line"; done

echo
echo "=== PDF Generation Complete ==="
echo "Next steps:"
echo "1. Review report_template.pdf"
echo "2. Update content with your actual experimental results"
echo "3. Replace placeholder data with real measurements"
echo "4. Add your analysis and conclusions"
echo "5. Rename to: 5204_Fall2025_ProgrammingAssignment1.pdf for submission"