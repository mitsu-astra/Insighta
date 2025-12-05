# Automatic Startup & Shutdown Guide

## Overview
The system now automatically starts and stops all required services including Docker, Backend, Frontend, and Monitoring services with a single command.

## Quick Start

### ✅ To Start Everything (Recommended)
**Option 1: Simple BAT file (Windows)**
```batch
START.bat
```

**Option 2: PowerShell (All platforms)**
```powershell
.\start-all.ps1
```

**Option 3: Quick Start (if dependencies already installed)**
```powershell
.\quick-start.ps1
```

### ⛔ To Stop Everything
**Option 1: Simple BAT file (Windows)**
```batch
STOP.bat
```

**Option 2: PowerShell**
```powershell
.\stop-all.ps1
```

---

## What Gets Started Automatically

### 1. **Docker Desktop** (Windows)
- ✅ Automatically detects if Docker is running
- ✅ Automatically starts Docker Desktop if not running
- ⏳ Waits 15 seconds for Docker to initialize
- 📝 Shows helpful messages if Docker startup fails

### 2. **Redis** (Docker Container)
- Running on port **6379**
- Used for caching and session management

### 3. **Prometheus** (Docker Container)
- Running on port **9090**
- Metrics collection and monitoring
- Access: `http://localhost:9090`

### 4. **Grafana** (Docker Container)
- Running on port **3001**
- Visualization and dashboards
- Access: `http://localhost:3001`
- Default Login: `team.808.test@gmail.com` / `team@808`

### 5. **Backend Server** (Node.js)
- Running on port **5000**
- Express server with MongoDB integration
- Access: `http://localhost:5000`
- Metrics: `http://localhost:5000/metrics`

### 6. **Frontend** (React + Vite)
- Running on port **3000**
- React development server
- Access: `http://localhost:3000`
- Auto-opens in default browser

---

## What Gets Stopped Automatically

When you press STOP or Ctrl+C, the system gracefully shuts down:
- ✅ All Node.js processes
- ✅ All service windows (PowerShell windows)
- ✅ Docker containers (Prometheus, Grafana, Redis)
- ✅ Clean shutdown without force kills

---

## Startup Process Details

### `start-all.ps1` (Full Installation)
Takes 2-3 minutes total:
1. [1/8] Install all npm dependencies (server, client, feedback-pipeline)
2. [2/8] Check/Start Docker Desktop (15 seconds if needed)
3. [3/8] Start Redis container
4. [4/8] Start Prometheus & Grafana
5. [5/8] Start Backend Server
6. [6/8] Start Frontend Server
7. [7/8] Open browser at http://localhost:3000
8. [8/8] Display service URLs and login credentials

### `quick-start.ps1` (Quick - No npm install)
Takes 30-45 seconds:
- Skips npm install (assumes dependencies already installed)
- Same Docker, backend, frontend startup process
- Ideal for subsequent runs

---

## Startup Progress Display

You'll see clear progress indicators:
```
================================================
  CRM Sentiment Analysis - Starting All Services
================================================

[1/8] Installing Node Dependencies...
[2/8] Checking Docker Desktop...
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
[8/8] Browser opened

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

## Stop Process Display

```
================================================
  CRM Sentiment Analysis - Stopping All Services
================================================

[1/4] Stopping Node.js processes...
  ✓ Node processes stopped
[2/4] Stopping service windows...
  ✓ Service windows closed
[3/4] Stopping Docker containers...
  ✓ Docker containers stopped
[4/4] Stopping Docker Compose services...
  ✓ Prometheus and Grafana stopped

================================================
  ✓ All Services Stopped!
================================================
```

---

## Service URLs Reference

| Service | URL | Purpose |
|---------|-----|---------|
| Frontend | http://localhost:3000 | React web application |
| Backend | http://localhost:5000 | Express.js API server |
| Metrics | http://localhost:5000/metrics | Backend metrics endpoint |
| Prometheus | http://localhost:9090 | Metrics database |
| Grafana | http://localhost:3001 | Dashboards & visualization |
| Redis | localhost:6379 | Cache/Session storage |

---

## Backend Services in Node.js

### Main Server
- **Port**: 5000
- **Starts**: Express server with metrics
- **Auto-restarts**: Redis/MongoDB failures are handled

### Feedback Pipeline Worker
- **Port**: 3006 (internal metrics)
- **Starts**: AI sentiment analysis processor
- **Auto-restarts**: If worker crashes, auto-restarts after 5 seconds

---

## Docker Service Management

### Manual Docker Controls (From Admin Dashboard)
- **Start Docker Services**: Admin Dashboard → Docker Control → Start
- **Stop Docker Services**: Admin Dashboard → Docker Control → Stop
- **Restart Docker Services**: Admin Dashboard → Docker Control → Restart

### From Command Line
```powershell
# Start Prometheus & Grafana
cd monitoring
docker-compose up -d prometheus grafana

# Stop services
docker-compose stop prometheus grafana

# View logs
docker-compose logs -f prometheus
docker-compose logs -f grafana
```

---

## Troubleshooting

### Docker Desktop Won't Start
**Problem**: Automatic Docker startup fails
```
⚠️  Could not start Docker Desktop automatically
   Please start it manually from your programs menu and try again
```
**Solution**:
1. Open Windows Start Menu
2. Search for "Docker Desktop"
3. Click to launch
4. Wait 15-20 seconds for it to fully start
5. Run the startup script again

### Port Already in Use
**Problem**: Port 3000, 5000, 9090, or 3001 already in use
```
Error: listen EADDRINUSE :::3000
```
**Solution**:
1. Stop other applications using that port
2. Or modify port in `.env` files

### npm install Takes Long
**Solution**: Use `quick-start.ps1` instead which skips npm install

### Services Won't Stop Gracefully
**Problem**: PowerShell windows won't close
**Solution**:
1. Run STOP.bat again
2. Or close windows manually
3. Or run `taskkill /F /IM node.exe` in PowerShell

---

## Environment Variables

Key environment variables (auto-set or defaults):

```env
# Server
PORT=5000
NODE_ENV=development

# MongoDB
MONGODB_URI=mongodb://localhost:27017/mern-auth
FEEDBACK_DB_URI=mongodb://localhost:27017/feedback_results

# Redis
REDIS_HOST=localhost
REDIS_PORT=6379

# Monitoring
PROMETHEUS_URL=http://localhost:9090
GRAFANA_URL=http://localhost:3001
```

---

## Performance Tips

1. **Use quick-start.ps1** after the first full startup
2. **Keep Docker Desktop running** for faster restarts
3. **Monitor resource usage** in Task Manager
4. **Close browser tabs** you're not using (React dev server uses memory)

---

## Advanced: Manual Service Startup

If you need to start services individually:

```powershell
# Start Backend only
cd server
npm start

# Start Frontend only
cd client
npm run dev

# Start Docker Monitoring only
cd monitoring
docker-compose up -d prometheus grafana

# Start Feedback Worker only
cd feedback-pipeline
npm start
```

---

## Service Dependencies

```
Docker (must be running first)
  ├── Redis
  ├── Prometheus
  └── Grafana
  
Backend (depends on MongoDB, Redis)
  └── Feedback Pipeline Worker

Frontend (depends on Backend)
```

---

## Log Locations

- **Backend**: Console window (real-time)
- **Frontend**: Console window (real-time)
- **Worker**: Console window (real-time)
- **Docker**: `docker logs crm_prometheus` / `docker logs crm_grafana`

---

## Next Steps

1. ✅ Run `START.bat` or `.\start-all.ps1`
2. ✅ Wait for all services to start (2-3 minutes)
3. ✅ Browser automatically opens to http://localhost:3000
4. ✅ Login with: `team.808.test@gmail.com` / `team@808`
5. ✅ Access monitoring at http://localhost:3001 (Grafana)

---

**Version**: 1.0 | **Updated**: December 2025
