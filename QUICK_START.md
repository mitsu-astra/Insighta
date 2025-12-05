# 🎯 Quick Reference - Start & Stop

## The Simplest Way

### 👉 TO START: Double-click `START.bat`
```
Automatic startup sequence:
1. ✅ Docker Desktop starts (if not running)
2. ✅ Redis container starts
3. ✅ Prometheus starts
4. ✅ Grafana starts
5. ✅ Backend server starts
6. ✅ Frontend starts
7. ✅ Browser opens automatically

⏱️  Takes 2-3 minutes first time
⏱️  Takes 30-45 seconds next times
```

### 👉 TO STOP: Double-click `STOP.bat`
```
Automatic shutdown sequence:
1. ✅ Stops all Node.js processes
2. ✅ Closes all service windows
3. ✅ Stops Docker containers
4. ✅ Clean graceful shutdown
```

---

## What to See When Starting

### ✅ You'll see this in PowerShell:
```
================================================
  CRM Sentiment Analysis - Starting All Services
================================================

[1/8] Installing Node Dependencies...
  ✓ Server dependencies installed
[2/8] Checking Docker Desktop...
  ✓ Docker is running
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

### ✅ You'll see multiple PowerShell windows open:
1. **Backend Server** (cyan/blue text)
2. **Feedback Pipeline Worker** (yellow text)
3. **Frontend Dev Server** (logs)

### ✅ Browser opens automatically to:
**http://localhost:3000**

---

## Service URLs (Remember These)

| What | Where | For What |
|------|-------|----------|
| **App** | http://localhost:3000 | Use the app |
| **API** | http://localhost:5000 | Backend API |
| **Grafana** | http://localhost:3001 | Dashboards (admin login) |
| **Prometheus** | http://localhost:9090 | Metrics database |

---

## Login Credentials

```
Email:    team.808.test@gmail.com
Password: team@808
```

---

## If Something Goes Wrong

### ❌ Docker won't start
```
⚠️  Could not start Docker Desktop automatically
```
**Fix**: 
1. Click Windows Start
2. Type "Docker"
3. Click "Docker Desktop"
4. Wait 20 seconds
5. Run START.bat again

### ❌ Port already in use
```
Error: listen EADDRINUSE
```
**Fix**: 
1. Run STOP.bat first
2. Close other apps using that port
3. Run START.bat again

### ❌ Services won't stop
**Fix**: Run STOP.bat again or close PowerShell windows manually

---

## Alternative: PowerShell Command

Instead of double-clicking, you can open PowerShell and type:

```powershell
# For first-time full installation
.\start-all.ps1

# For quick restart (skips npm install)
.\quick-start.ps1

# To stop everything
.\stop-all.ps1
```

---

## How the Magic Works

```
START.bat
    ↓
start-all.ps1 (PowerShell script)
    ↓
1. Check Docker → Start if needed (15 sec wait)
    ↓
2. Start Redis (Docker)
    ↓
3. Start Prometheus & Grafana (Docker)
    ↓
4. Install npm dependencies (first time only)
    ↓
5. Start Backend Server (separate window)
    ↓
6. Start Frontend Server (separate window)
    ↓
7. Open Browser
    ↓
✅ DONE! Everything Running
```

---

## For Next Startup

```
💡 Tip: Use quick-start.ps1 instead of start-all.ps1
   (skips npm install, much faster!)

   Windows Explorer → c:\PS_sample
   Right-click → Open with PowerShell ISE
   
   Then run: .\quick-start.ps1
```

---

## Architecture

```
                    Your Computer
                          |
        __________________|__________________
       |                  |                  |
    Docker             Node.js            Browser
       |                  |                  |
     __|__            ____|____          ____|____
    |  |  |          |  |  |  |         |        |
   Re Pr Gr         Be Wo Me Fe        App Display
   di om af         nd rk tr nd        (localhost:3000)
   s   
                    Re = Redis
                    Pr = Prometheus
                    Gr = Grafana
                    Be = Backend
                    Wo = Worker
                    Me = Metrics
                    Fe = Frontend
```

---

## Dashboard Flow

```
1. Open http://localhost:3000
2. Login: team.808.test@gmail.com / team@808
3. Navigate to Analytics (see stats)
4. Navigate to Admin Dashboard (manage system)
5. Click "Docker Control" to manage services
6. Open http://localhost:3001 for Grafana dashboards
```

---

## Troubleshooting Checklist

- [ ] Docker Desktop installed?
- [ ] 15GB free disk space?
- [ ] Ports not blocked (3000, 5000, 3001, 9090)?
- [ ] MongoDB local or running?
- [ ] Redis starting in Docker?
- [ ] npm installed? (`npm --version`)
- [ ] Running as Administrator? (try this if issues)

---

## Performance Notes

- **First startup**: 2-3 minutes (installs dependencies)
- **Next startups**: 30-45 seconds
- **Docker startup**: 15-20 seconds (automatic wait)
- **Browser load**: 5-10 seconds

---

## When You're Done

```
1. Run STOP.bat
2. Or press Ctrl+C in PowerShell windows
3. Or close each PowerShell window
4. Or in Docker: docker-compose down
```

---

## Need More Details?

📖 Read: `STARTUP_GUIDE.md` (complete documentation)
📖 Read: `CHANGES_SUMMARY.md` (what was changed)

---

**Status**: ✅ Ready to Go!  
**Last Updated**: December 5, 2025

🚀 **Now run `START.bat` and everything will start automatically!**
