# ⏰ tmux Guide for Long-Running Assignments

## 🎯 Why Use tmux?

tmux allows you to:
- ✅ Start assignment and **go home**
- ✅ **Safely disconnect** without stopping the job
- ✅ **Reconnect later** to check progress
- ✅ **Survive network interruptions**
- ✅ **Monitor multiple processes** simultaneously

---

## 🚀 Basic tmux Commands

### **Starting a Session**
```bash
# Create new session named 'assignment1'
tmux new-session -s assignment1

# Create session and run command immediately
tmux new-session -d -s assignment1 "cd ~/programming1 && ./run_complete_assignment.sh"
```

### **Managing Sessions**
```bash
# List all sessions
tmux list-sessions

# Attach to existing session
tmux attach-session -t assignment1

# Kill a session
tmux kill-session -t assignment1
```

### **Inside tmux Session**
```bash
# Detach (keeps running): Ctrl+B, then D
# Create new window: Ctrl+B, then C
# Switch windows: Ctrl+B, then 0-9
# Split pane: Ctrl+B, then % (vertical) or " (horizontal)
```

---

## 🎯 Complete Assignment Workflow

### **Step 1: Start Assignment in tmux**
```bash
# SSH to CSELabs
ssh hasan181@keller-lab.cs.umn.edu

# Navigate to assignment
cd ~/programming1

# Start tmux session
tmux new-session -s assignment1

# Run assignment (inside tmux)
./run_complete_assignment.sh
```

### **Step 2: Detach and Go Home**
```bash
# Press Ctrl+B, then D to detach
# Session continues running in background
# You can now close terminal and go home
```

### **Step 3: Check Progress Later**
```bash
# SSH back to CSELabs (from home or next day)
ssh hasan181@keller-lab.cs.umn.edu

# Reattach to your session
tmux attach-session -t assignment1

# Check progress - you'll see current output
```

---

## 📊 Advanced Monitoring Setup

### **Multi-Pane Monitoring**
```bash
# Create session with multiple panes
tmux new-session -s assignment1

# Split into panes (inside tmux)
# Ctrl+B, then % (split vertically)
# Ctrl+B, then " (split horizontally)

# Pane 1: Run assignment
./run_complete_assignment.sh

# Pane 2: Monitor processes
watch -n 30 'ps aux | grep -E "(verilator|bluesim|gem5)" | grep hasan181'

# Pane 3: Monitor disk usage
watch -n 60 'df -h /export/scratch/users/hasan181'

# Pane 4: Watch log files
tail -f *.txt
```

### **Automatic Progress Logging**
```bash
# Create comprehensive monitoring script
cat > monitor.sh << 'EOF'
#!/bin/bash
while true; do
    echo "=== Progress Update: $(date) ===" >> progress.log
    
    # Check if main script is running
    if pgrep -f "run_complete_assignment.sh" > /dev/null; then
        echo "✅ Assignment running" >> progress.log
    else
        echo "❌ Assignment stopped" >> progress.log
    fi
    
    # Log file sizes
    echo "Log sizes:" >> progress.log
    ls -lh *.txt 2>/dev/null >> progress.log
    
    # Current processes
    echo "Active processes:" >> progress.log
    ps aux | grep -E "(verilator|bluesim|gem5)" | grep hasan181 >> progress.log
    
    echo "" >> progress.log
    sleep 300  # Update every 5 minutes
done
EOF

chmod +x monitor.sh

# Run monitoring in background
./monitor.sh &
```

---

## 🔒 Ultra-Safe Execution

### **Method 1: tmux + nohup**
```bash
# Double protection against disconnection
tmux new-session -d -s assignment1 "nohup ./run_complete_assignment.sh > assignment.log 2>&1 && echo 'COMPLETED' > completion.flag"
```

### **Method 2: Nested Protection**
```bash
# tmux session with screen backup
tmux new-session -s assignment1
screen -S backup
./run_complete_assignment.sh
```

### **Method 3: Auto-Restart on Failure**
```bash
cat > safe_run.sh << 'EOF'
#!/bin/bash
while true; do
    echo "Starting assignment at $(date)" >> restart.log
    if ./run_complete_assignment.sh; then
        echo "Assignment completed successfully at $(date)" >> restart.log
        break
    else
        echo "Assignment failed, restarting in 60 seconds..." >> restart.log
        sleep 60
    fi
done
EOF

chmod +x safe_run.sh
tmux new-session -d -s assignment1 "./safe_run.sh"
```

---

## 🔍 Status Checking Scripts

### **Quick Status Check**
```bash
cat > check_status.sh << 'EOF'
#!/bin/bash
echo "=== Assignment Status Check ==="
echo "Time: $(date)"
echo

if tmux has-session -t assignment1 2>/dev/null; then
    echo "✅ tmux session exists"
    
    # Check completion
    if [ -f "completion.flag" ]; then
        echo "🎉 ASSIGNMENT COMPLETED!"
    elif pgrep -f "run_complete_assignment.sh" > /dev/null; then
        echo "⏳ Assignment running..."
    else
        echo "⚠️ Assignment may have stopped"
    fi
else
    echo "❌ No tmux session found"
fi

# Log summary
echo
echo "📊 Progress Summary:"
echo "RTL logs: $(wc -l < rtl_simulation_log.txt 2>/dev/null || echo 0) lines"
echo "GEM5 logs: $(wc -l < gem5_simulation_log.txt 2>/dev/null || echo 0) lines"
echo "ALU logs: $(wc -l < alu_test_log.txt 2>/dev/null || echo 0) lines"
EOF

chmod +x check_status.sh
```

### **Remote Status Check**
```bash
# From your home computer
ssh hasan181@keller-lab.cs.umn.edu "cd ~/programming1 && ./check_status.sh"
```

---

## 📱 Mobile-Friendly Monitoring

### **Simple SMS-style Updates**
```bash
# Add to your monitoring script
echo "Assignment $(date +%H:%M): $(if pgrep -f assignment >/dev/null; then echo RUNNING; else echo STOPPED; fi)" >> status.txt
```

### **Email Notifications (if available)**
```bash
# Add to completion script
echo "Assignment completed at $(date)" | mail -s "Assignment Done" your-email@umn.edu
```

---

## 🆘 tmux Troubleshooting

### **Common Issues**

**Session Not Found:**
```bash
# List all sessions
tmux list-sessions

# Create new if needed
tmux new-session -s assignment1
```

**Can't Attach:**
```bash
# Kill zombie sessions
tmux kill-server

# Start fresh
tmux new-session -s assignment1
```

**Lost Session:**
```bash
# Check if process still running
ps aux | grep -f "run_complete_assignment.sh" | grep hasan181

# Check log files for progress
tail -f ~/programming1/*.txt
```

### **Recovery Commands**
```bash
# If tmux crashes, check for running processes
pgrep -f "run_complete_assignment.sh"

# If process exists, create new tmux around it
tmux new-session -d -s recovery

# Manual monitoring
watch -n 30 'ps aux | grep hasan181'
```

---

## 🏁 Completion Detection

### **Automatic Completion Check**
```bash
# Add to your script
while ! grep -q "Assignment Complete" *.txt 2>/dev/null; do
    sleep 300  # Check every 5 minutes
done

# Send notification
echo "🎉 Assignment completed at $(date)!" > completion_notice.txt
```

---

**With tmux, you can confidently start your 8-14 hour assignment and go home! 🏠✨**