# 🚀 Automatic Startup/Shutdown - Changes Summary

## What Changed

Your system now has **complete automated startup and shutdown** of all required applications including Docker. Press START and everything boots up automatically. Press STOP and everything gracefully shuts down.

---

## Key Changes Made

### 1️⃣ **start-all.ps1** (Full Startup Script)
**What's New:**
- ✅ Automatically detects if Docker is running
- ✅ Auto-starts Docker Desktop if not running (15-20 second wait)
- ✅ Installs all npm dependencies (server, client, feedback-pipeline)
- ✅ Starts Redis (port 6379)
- ✅ Starts Prometheus (port 9090)
- ✅ Starts Grafana (port 3001)
- ✅ Starts Backend (port 5000)
- ✅ Starts Frontend (port 3000)
- ✅ Auto-opens browser to http://localhost:3000

**Progress indicators**: Shows clear [1/8], [2/8], etc. steps with ✓ or ⚠️ icons

---

### 2️⃣ **quick-start.ps1** (Fast Startup)
**What's New:**
- ✅ Skips npm install (for faster restarts)
- ✅ Automatically starts Docker Desktop if needed
- ✅ Same service startup as full version
- ⏱️ Takes 30-45 seconds instead of 2-3 minutes

**Use this** after your first full startup!

---

### 3️⃣ **stop-all.ps1** (Graceful Shutdown)
**What's New:**
- ✅ Stops all Node.js processes
- ✅ Closes all service windows (PowerShell windows)
- ✅ Stops Docker containers gracefully
- ✅ Stops Docker Compose services (Prometheus, Grafana)
- ✅ Clean shutdown process (no force kills)

**Much better** than just clicking X!

---

### 4️⃣ **server/start.js** (Backend Auto-Start)
**What's New:**
- ✅ Server now starts Docker & monitoring services on boot
- ✅ Auto-detects and starts Docker Desktop on Windows
- ✅ Automatically starts Prometheus & Grafana containers
- ✅ Shows helpful status messages during startup

**So when you start the backend**, Docker is already running!

---

### 5️⃣ **adminController.js** (Admin Panel Docker Control)
**What's New:**
- ✅ Docker start button auto-starts Docker Desktop if needed
- ✅ Waits 15 seconds for Docker to initialize
- ✅ Better error messages with specific solutions
- ✅ Guides users if Docker isn't found or can't start

**Admin dashboard** Docker controls now work even if Docker wasn't running!

---

### 6️⃣ **START.bat & STOP.bat** (Windows Shortcuts)
**What's New:**
- ✅ Updated to use new PowerShell scripts
- ✅ Simple one-click startup/shutdown
- ✅ Now handles Docker automatically

**Just double-click** to start/stop everything!

---

## How to Use

### To Start Everything (Pick One)

```powershell
# Option 1: Simple BAT file (easiest)
START.bat

# Option 2: PowerShell Full Install (first time)
.\start-all.ps1

# Option 3: PowerShell Quick Start (after first run)
.\quick-start.ps1
```

### To Stop Everything (Pick One)

```powershell
# Option 1: Simple BAT file (easiest)
STOP.bat

# Option 2: PowerShell
.\stop-all.ps1

# Option 3: From running terminal
Press Ctrl+C
```

---

## What Gets Started Automatically

```
Docker Desktop (auto-started if needed)
├── Redis (port 6379)
├── Prometheus (port 9090)
└── Grafana (port 3001)

Backend Server (port 5000)
├── Express API
├── MongoDB connection
├── Feedback Pipeline Worker (port 3006)
└── Metrics collection

Frontend (port 3000)
└── React + Vite dev server (auto-opens browser)
```

---

## Service Ports Reference

| Service | Port | Access |
|---------|------|--------|
| Frontend | 3000 | http://localhost:3000 |
| Backend | 5000 | http://localhost:5000 |
| Grafana | 3001 | http://localhost:3001 |
| Prometheus | 9090 | http://localhost:9090 |
| Redis | 6379 | localhost:6379 |
| Worker Metrics | 3006 | http://localhost:3006 |

---

## What Gets Stopped Gracefully

✅ All Node.js processes
✅ All PowerShell service windows
✅ All Docker containers
✅ All Docker Compose services

**No more orphaned processes!**

---

## Progress Display Example

When you start, you'll see:
```
================================================
  CRM Sentiment Analysis - Starting All Services
================================================

[1/8] Installing Node Dependencies...
  ✓ Server dependencies installed
  ✓ Client dependencies installed
  ✓ Feedback-pipeline dependencies installed
[2/8] Checking Docker Desktop...
  Docker not running, starting Docker Desktop...
  ⏳ Waiting 15 seconds for Docker to initialize...
  ✓ Docker Desktop started
[3/8] Starting Redis...
  ✓ Redis running on port 6379
[4/8] Starting Prometheus & Grafana...
  ✓ Prometheus running on http://localhost:9090
  ✓ Grafana running on http://localhost:3001
[5/8] Starting Backend Server...
  ✓ Backend starting on http://localhost:5000
[6/8] Starting Frontend...
  ✓ Frontend starting on http://localhost:3000
[7/8] Opening browser...
  ✓ Browser opened
[8/8] Complete!

================================================
  ✓ All Services Started!
================================================

  Frontend:    http://localhost:3000
  Backend:     http://localhost:5000
  Grafana:     http://localhost:3001
  Prometheus:  http://localhost:9090

  Admin Login:
    Email:    team.808.test@gmail.com
    Password: team@808
```

---

## Time to Startup

- **First run** (start-all.ps1): 2-3 minutes (includes npm install)
- **Subsequent runs** (quick-start.ps1): 30-45 seconds
- **Docker startup time**: 15-20 seconds (automatic)

---

## Error Handling

### If Docker won't start automatically:
```
⚠️  Could not start Docker Desktop automatically
   Please start it manually from your programs menu and try again
```
Solution: Start Docker Desktop manually → Wait 20 seconds → Run script again

### If port is already in use:
```
Error: listen EADDRINUSE :::3000
```
Solution: Close the app using that port or modify PORT in .env

---

## Files Modified

| File | Change |
|------|--------|
| `start-all.ps1` | ✅ Auto Docker startup, improved progress display |
| `quick-start.ps1` | ✅ Docker startup, auto browser open |
| `stop-all.ps1` | ✅ Graceful shutdown, PowerShell window cleanup |
| `server/start.js` | ✅ Auto starts Docker & Prometheus/Grafana |
| `server/controllers/adminController.js` | ✅ Auto Docker startup in API endpoint |
| `START.bat` | ✅ Points to new scripts |
| `STOP.bat` | ✅ Points to new stop script |
| `STARTUP_GUIDE.md` | ✅ NEW - Complete startup documentation |

---

## Benefits

✅ **One-click startup** - Everything starts automatically
✅ **Docker handled** - No manual Docker Desktop startup needed
✅ **Graceful shutdown** - All services stop cleanly
✅ **Clear feedback** - Progress indicators show what's happening
✅ **Smart error messages** - Tells you exactly what went wrong
✅ **Auto-restarts** - Failed services auto-restart (Worker)
✅ **Browser opens** - Automatically navigates to app
✅ **Consistent** - Same startup every time

---

## Next Steps

1. Open PowerShell or CMD in `c:\PS_sample`
2. Run: `.\START.bat` or `.\start-all.ps1`
3. Wait for browser to open (2-3 minutes first time)
4. Login with: `team.808.test@gmail.com` / `team@808`
5. Access monitoring dashboards at http://localhost:3001
6. When done, run: `.\STOP.bat` or `.\stop-all.ps1`

---

**Version**: 1.0  
**Updated**: December 5, 2025  
**Status**: ✅ Ready to Use
