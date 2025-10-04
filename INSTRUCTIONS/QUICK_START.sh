#!/bin/bash

# 🚀 QUICK START - Programming Assignment 1
# Copy and paste these commands on CSELabs for instant execution

echo "=== QUICK START - Programming Assignment 1 ==="
echo "Student: hasan181 | Teammate: suh00051"
echo "Time: $(date)"
echo

# Ensure we're in the right directory
if [ ! -f "run_complete_assignment.sh" ]; then
    echo "❌ ERROR: Not in programming1 directory!"
    echo "Run: cd ~/programming1"
    echo "Then run this script again."
    exit 1
fi

echo "📁 Current directory: $(pwd)"
echo "✅ Found assignment files"
echo

# Make all scripts executable
echo "🔧 Making scripts executable..."
chmod +x *.sh
chmod +x INSTRUCTIONS/*.sh

echo "🔍 Running pre-flight check..."
./preflight_check.sh

echo
echo "🎯 Choose execution method:"
echo "1. Run with tmux (RECOMMENDED - can disconnect safely)"
echo "2. Run directly (must stay connected for 8-14 hours)"
echo

read -p "Enter choice (1 or 2): " choice

case $choice in
    1)
        echo "🚀 Starting assignment with tmux..."
        echo "You can safely disconnect after this starts."
        echo
        
        # Create tmux session and run assignment
        tmux new-session -d -s assignment1 "cd $(pwd) && ./run_complete_assignment.sh && echo 'ASSIGNMENT COMPLETED! Press any key to continue...' && read"
        
        echo "✅ Assignment started in tmux session 'assignment1'"
        echo
        echo "📋 Important Commands:"
        echo "  - Attach to session: tmux attach -t assignment1"
        echo "  - Detach safely: Ctrl+B, then D"
        echo "  - Check status: tmux list-sessions"
        echo
        echo "🏠 You can now safely disconnect and go home!"
        echo "🕐 Come back in 8-14 hours to check results"
        echo
        echo "To monitor progress:"
        echo "  ssh hasan181@keller-lab.cs.umn.edu"
        echo "  tmux attach -t assignment1"
        
        # Give option to attach immediately
        echo
        read -p "Attach to tmux session now? (y/n): " attach
        if [ "$attach" = "y" ] || [ "$attach" = "Y" ]; then
            echo "Attaching to tmux session..."
            echo "Remember: Ctrl+B then D to detach safely"
            sleep 2
            tmux attach-session -t assignment1
        fi
        ;;
        
    2)
        echo "⚠️  WARNING: You must stay connected for 8-14 hours!"
        echo "🚀 Starting assignment directly..."
        sleep 3
        ./run_complete_assignment.sh
        ;;
        
    *)
        echo "❌ Invalid choice. Please run again and select 1 or 2."
        exit 1
        ;;
esac

echo
echo "=== QUICK START COMPLETE ==="