# ✅ Setup Verification Checklist

## Pre-Flight Checklist

Before running START.bat for the first time, verify these items:

### System Requirements
- [ ] Windows 10 or Windows 11
- [ ] 8GB RAM minimum (16GB recommended)
- [ ] 15GB free disk space
- [ ] Administrator access on computer

### Software Installed
- [ ] Docker Desktop installed (`C:\Program Files\Docker\Docker\Docker Desktop.exe`)
- [ ] Node.js installed (`npm --version` works)
- [ ] PowerShell 5.0+ available
- [ ] Internet connection active

### Port Availability
- [ ] Port 3000 not in use (Frontend)
- [ ] Port 5000 not in use (Backend)
- [ ] Port 3001 not in use (Grafana)
- [ ] Port 9090 not in use (Prometheus)
- [ ] Port 6379 not in use (Redis)

### Database
- [ ] MongoDB running locally OR
- [ ] MongoDB Atlas connection string configured

### Files Present
- [ ] `c:\PS_sample\START.bat` exists
- [ ] `c:\PS_sample\STOP.bat` exists
- [ ] `c:\PS_sample\start-all.ps1` exists
- [ ] `c:\PS_sample\quick-start.ps1` exists
- [ ] `c:\PS_sample\stop-all.ps1` exists

### Network
- [ ] Firewall allows Docker
- [ ] Firewall allows Node.js
- [ ] DNS working (`ping google.com` works)

---

## First-Time Startup Checklist

### Step 1: Prepare
- [ ] Close other applications (especially those using ports 3000-9090)
- [ ] Open PowerShell or Command Prompt
- [ ] Navigate to `c:\PS_sample`

### Step 2: Start
- [ ] Double-click `START.bat` or run `.\start-all.ps1`
- [ ] Watch the progress display
- [ ] Allow 15 seconds for Docker to start
- [ ] Allow 2-3 minutes for full startup

### Step 3: Verify Running
- [ ] PowerShell window shows `✓` symbols
- [ ] Browser opens to http://localhost:3000
- [ ] No red error messages (warnings ⚠️ are OK)

### Step 4: Test Access
- [ ] Frontend loads at http://localhost:3000
- [ ] Backend accessible at http://localhost:5000
- [ ] Prometheus accessible at http://localhost:9090
- [ ] Grafana accessible at http://localhost:3001

### Step 5: Login
- [ ] Login page displays
- [ ] Email: `team.808.test@gmail.com`
- [ ] Password: `team@808`
- [ ] Successfully logs in

### Step 6: Verify Services
- [ ] Analytics page loads
- [ ] Dashboard shows data
- [ ] Admin panel accessible
- [ ] Docker controls visible

---

## Successful Startup Indicators

### PowerShell Display
```
✓ You should see ALL of these:
  [1/8] Installing Node Dependencies...
  [2/8] Checking Docker Desktop...
  [3/8] Starting Redis...
  [4/8] Starting Prometheus & Grafana...
  [5/8] Starting Backend Server...
  [6/8] Starting Frontend...
  [7/8] Opening browser...
  [8/8] Complete!

✓ Final message:
  ✓ All Services Started!
```

### Process Windows
```
✓ You should see these PowerShell windows:
  1. Main script output (progress display)
  2. Backend Server (cyan text)
  3. Feedback Worker (yellow text)
  4. Frontend Server (dev server logs)
```

### Browser
```
✓ Browser auto-opens to:
  http://localhost:3000

✓ Login page shows:
  Email field
  Password field
  Submit button
```

### Performance
```
✓ First startup: 2-3 minutes total
✓ Docker starts: 15-20 seconds
✓ npm install: 45-60 seconds
✓ Services startup: 30-45 seconds
✓ Browser load: 5-10 seconds
```

---

## Common Startup Issues & Fixes

### ❌ Docker won't start
**Symptom**: `Docker not running` message persists
**Fix**:
1. [ ] Manual start: Click Windows Start → Type "Docker" → Click Docker Desktop
2. [ ] Wait 20 seconds for Docker to fully initialize
3. [ ] Run START.bat again

### ❌ Port already in use
**Symptom**: `Error: listen EADDRINUSE` for port 3000/5000/etc
**Fix**:
1. [ ] Run STOP.bat first
2. [ ] Check what's using port: `netstat -ano | findstr :3000`
3. [ ] Close conflicting application
4. [ ] Run START.bat again

### ❌ npm install fails
**Symptom**: Red error messages during dependency installation
**Fix**:
1. [ ] Check internet connection: `ping google.com`
2. [ ] Clear npm cache: `npm cache clean --force`
3. [ ] Delete `node_modules` folders: `for /d /r . %d in (node_modules) do @if exist "%d" (rd /s/q "%d")`
4. [ ] Run START.bat again

### ❌ Browser won't open automatically
**Symptom**: PowerShell shows `Could not open browser automatically`
**Fix**:
1. [ ] Manually open browser
2. [ ] Type: http://localhost:3000
3. [ ] Everything else should be working fine

### ❌ Backend server won't start
**Symptom**: Backend window shows errors
**Fix**:
1. [ ] Check MongoDB is running: `mongosh`
2. [ ] Check Node.js works: `node --version`
3. [ ] Check .env file exists: `server/.env`
4. [ ] Check ports available: `netstat -ano | findstr :5000`

### ❌ Grafana login fails
**Symptom**: Can't login to Grafana at http://localhost:3001
**Fix**:
1. [ ] Try default: `admin` / `admin`
2. [ ] Container might need 10-15 seconds to fully start
3. [ ] Refresh page (Ctrl+R)
4. [ ] Clear browser cache

---

## Post-Startup Verification

### URLs to Check
- [ ] `http://localhost:3000` - Frontend (should load)
- [ ] `http://localhost:5000` - Backend (should show API)
- [ ] `http://localhost:5000/metrics` - Metrics (should show Prometheus format)
- [ ] `http://localhost:9090` - Prometheus (should show metrics UI)
- [ ] `http://localhost:3001` - Grafana (should show login)

### Docker Containers
```powershell
# Verify these are running:
docker ps

✓ Should show:
  crm_redis
  crm_prometheus
  crm_grafana
  (and any other containers)
```

### Processes
```powershell
# Verify these are running:
Get-Process | Where-Object {$_.Name -like "*node*"}

✓ Should show:
  Multiple node.exe processes
```

### Logs to Check
- [ ] Backend console: Shows "Server is running at http://localhost:5000"
- [ ] Frontend console: Shows "vite v...  local: http://localhost:3000"
- [ ] Worker console: Shows "Worker started"

---

## Stop & Cleanup Checklist

### Safe Shutdown
- [ ] Run STOP.bat or `.\stop-all.ps1`
- [ ] Wait for all windows to close
- [ ] Verify no node.exe processes remain: `Get-Process node -ErrorAction SilentlyContinue`

### Docker Cleanup (Optional)
```powershell
# Remove unused containers/images
docker container prune
docker image prune
```

### Full System Reset (If Needed)
```powershell
# Stop everything
.\stop-all.ps1

# Remove all containers
docker container prune --force

# Remove all images
docker image prune --force

# Start fresh
.\start-all.ps1
```

---

## Quick Diagnostics

### Test Docker
```powershell
docker ps                    # Lists running containers
docker --version             # Shows Docker version
docker-compose --version     # Shows Docker Compose version
```

### Test Node.js
```powershell
node --version              # Shows Node version
npm --version               # Shows npm version
npm list -g                 # Lists global packages
```

### Test Ports
```powershell
netstat -ano | findstr :3000   # Check port 3000
netstat -ano | findstr :5000   # Check port 5000
netstat -ano | findstr :9090   # Check port 9090
```

### Test MongoDB
```powershell
mongosh --version           # Check if MongoDB tools installed
# Then try to connect to your MongoDB instance
```

---

## Success Criteria

✅ **Startup is successful when:**
1. [ ] All [1/8] through [8/8] steps complete
2. [ ] No error messages (warnings OK)
3. [ ] Browser opens to http://localhost:3000
4. [ ] Login page displays
5. [ ] Can log in with provided credentials
6. [ ] Dashboard shows data
7. [ ] Grafana accessible at http://localhost:3001

✅ **System is healthy when:**
- [ ] Frontend responds in <2 seconds
- [ ] Backend API responds in <1 second
- [ ] Prometheus shows metrics
- [ ] No red errors in console
- [ ] Docker containers running
- [ ] Services survive browser refresh

---

## Next Steps After Startup

1. [ ] Login to application
2. [ ] Test core functionality (analytics, dashboard, etc.)
3. [ ] Check Grafana dashboards (http://localhost:3001)
4. [ ] Verify data is flowing through pipeline
5. [ ] Create test feedback to verify analytics
6. [ ] Test admin controls
7. [ ] Test Docker controls in admin panel

---

## When You're Ready to Stop

```powershell
# Option 1: Simple
Double-click STOP.bat

# Option 2: Command line
.\stop-all.ps1

# Option 3: Terminal
Ctrl+C in any running PowerShell window
```

---

## Support Resources

- `QUICK_START.md` - Visual quick reference
- `STARTUP_GUIDE.md` - Complete detailed guide
- `CHANGES_SUMMARY.md` - What was changed
- Backend logs - Check server PowerShell window
- Frontend logs - Check client PowerShell window
- Docker logs - `docker logs crm_prometheus` or `docker logs crm_grafana`

---

## Completion Status

**Checklist Complete!** ✅

You're now ready to:
- [ ] Run START.bat to start all services
- [ ] Use the application
- [ ] Run STOP.bat to shutdown all services

---

**Version**: 1.0  
**Date**: December 5, 2025  
**Status**: ✅ Ready for First Startup
