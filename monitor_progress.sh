#!/bin/bash
echo "=== GEM5 Simulation Monitor ==="
echo "Started at: $(date)"
echo "Checking every 5 minutes for completion..."
echo

while true; do
    # Check if GEM5 is running
    if ps aux | grep -E "(gem5|scons)" | grep -v grep > /dev/null; then
        echo "$(date): GEM5 simulation running..."
    else
        echo "$(date): No GEM5 processes found. Checking for results..."
        
        # Check for completed simulations
        COMPLETED=$(find /export/scratch/users/hasan181/parsec-tests -name "stats.txt" -exec grep -l "simTicks\|cpi\|hostSeconds" {} \; 2>/dev/null | wc -l)
        
        if [ $COMPLETED -gt 0 ]; then
            echo "✅ Found $COMPLETED completed simulation(s)!"
            echo "Running final analysis..."
            cd /home/hasan181/programming1
            python3 analyze_results.py
            ./generate_pdf.sh
            echo "🎉 ASSIGNMENT COMPLETE! Check report_template.pdf"
            break
        else
            echo "No completed results yet. Will check again in 5 minutes..."
        fi
    fi
    
    sleep 300  # Wait 5 minutes
done
