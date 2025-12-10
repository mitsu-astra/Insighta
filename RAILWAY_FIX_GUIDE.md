# Railway Fix - Docker Deployment Guide

## ✅ Issue Fixed

Railway wasn't displaying the application because:
1. ❌ Root Dockerfile tried to run multiple services (not supported on Railway)
2. ❌ Client and server were not properly integrated
3. ❌ Static assets were not being served

## ✅ Solution Applied

### 1. **New Architecture**
- **Main service** (Dockerfile) - Express server + built React app
- **Optional API service** (Dockerfile.api) - Separate feedback API
- **Optional Worker service** (Dockerfile.worker) - Async worker

### 2. **Files Updated**
- ✅ `Dockerfile` - Now builds client and serves it with server
- ✅ `server/server.js` - Updated to serve client assets
- ✅ `railway.json` - Simplified for single main service
- ✅ New: `Dockerfile.api` - For optional API service
- ✅ New: `Dockerfile.worker` - For optional worker service
- ✅ New: `railway-services.toml` - For multi-service setup

## 🚀 Deployment Options

### Option A: Simple Deployment (Recommended for First Deploy)

**Just the main service (Server + Client):**

```bash
# 1. Commit changes
git add .
git commit -m "Fix Railway Docker deployment"
git push origin main

# 2. In Railway Dashboard:
# - Connect GitHub repo
# - Railway auto-detects Dockerfile
# - Set environment variables
# - Deploy

# 3. Environment Variables (CRITICAL)
MONGO_URI=mongodb+srv://...
JWT_SECRET=your-secret
CLIENT_URL=https://your-app.railway.app
REDIS_HOST=your-redis
REDIS_PORT=6379
VITE_API_URL=https://your-app.railway.app
```

**Result**: Full app on single service (client + server)

### Option B: Multi-Service Deployment

**Separate services for API and Worker:**

```bash
# 1. Create Railway project with main service first
# 2. Add API service
railway service create --name api --dockerfile Dockerfile.api

# 3. Add Worker service
railway service create --name worker --dockerfile Dockerfile.worker

# 4. Share environment variables across services
# Set in Railway variables, they're available to all services
```

**Result**: Main service handles UI + backend, API and Worker run separately

## 📝 Environment Variables Needed

### For Main Service (Always Required)
```
MONGO_URI                 # MongoDB connection
MONGO_DB                  # Database name (default: feedback_pipeline)
JWT_SECRET                # Auth secret
CLIENT_URL                # Your Railway app URL
REDIS_HOST                # Redis host
REDIS_PORT                # Redis port (6379)
NODE_ENV                  # Set to "production"
PORT                      # Set to 4000 (or let Railway assign)
```

### For Optional Services
```
# If running separate API service:
AI_API_KEY                # Hugging Face token
API_PORT                  # Set to 3005

# If running separate Worker:
WORKER_CONCURRENCY        # Number of parallel jobs
WORKER_METRICS_PORT       # Metrics port (3006)
```

## ✅ Deployment Steps

### Step 1: Commit & Push
```bash
cd C:\Users\amrut\OneDrive\Desktop\Insighta\Insighta
git add .
git commit -m "Fix Docker deployment for Railway"
git push origin main
```

### Step 2: Connect to Railway

**Via Dashboard (Easiest):**
1. Go to https://railway.app
2. Create new project
3. Click "Deploy from GitHub"
4. Select your repository
5. Railway auto-detects `Dockerfile`

**Via CLI:**
```bash
railway login
railway init
railway link
```

### Step 3: Set Environment Variables

**In Railway Dashboard:**
1. Go to your project
2. Click "Variables"
3. Add each variable from the list above
4. Click "Save"

**Via CLI:**
```bash
railway variables set MONGO_URI "mongodb+srv://..."
railway variables set JWT_SECRET "your-secret"
# ... repeat for all variables
```

### Step 4: Deploy

Push to main and Railway auto-deploys:
```bash
git push origin main
```

Or manually:
```bash
railway deploy
```

### Step 5: Verify

```bash
# Check logs
railway logs -f

# Check status
railway status

# Open app
railway open
```

## 🔍 How It Works Now

```
User Request
    ↓
[Railway Main Service - Port 4000]
    ├─ Express Server (Node.js)
    ├─ Serves React App (from /public/dist)
    ├─ Handles /api/* routes
    ├─ Connects to MongoDB
    └─ Connects to Redis for jobs
    ↓
User sees React UI + Backend works
```

## 🛠️ Troubleshooting

### Issue: "Cannot GET /"
**Solution:**
- Verify client built: Check if `dist/` folder exists
- Check Dockerfile copied client: `COPY --from=build-client /app/client/dist ./public/dist`
- Check server serves it: `app.use(express.static(publicPath));`
- View logs: `railway logs`

### Issue: "Cannot POST /api/auth/..."
**Solution:**
- Verify API routes are loaded
- Check MONGO_URI is correct
- Check Redis connection (if queue is needed)
- View detailed logs: `railway logs -f`

### Issue: "Docker build fails"
**Solution:**
- Check Node version compatibility (using 20-alpine)
- Verify all dependencies in package.json
- Check npm install works locally first
- View build logs: `railway logs --build`

### Issue: "App running but shows blank page"
**Solution:**
- Clear browser cache
- Check browser console for errors
- Verify VITE_API_URL matches server URL
- Check if client built correctly

## 📊 File Structure

```
Your app now deploys as:

┌─────────────────────────────────────┐
│     Railway Main Service (4000)      │
├─────────────────────────────────────┤
│  ┌──────────────────────────────┐   │
│  │  React App (from /public)    │   │
│  │  (Served by Express)         │   │
│  │  Port: 80 via Nginx proxy    │   │
│  └──────────────────────────────┘   │
│                                     │
│  ┌──────────────────────────────┐   │
│  │  Express Backend             │   │
│  │  - /api/* routes             │   │
│  │  - MongoDB connection        │   │
│  │  - Static file serving       │   │
│  │  - Port: 4000                │   │
│  └──────────────────────────────┘   │
└─────────────────────────────────────┘
         ↓ ↓ ↓
   [MongoDB, Redis, etc.]
```

## ✨ Key Changes Summary

| Before | After | Impact |
|--------|-------|--------|
| Multiple background processes | Single main process | ✅ Works on Railway |
| Client & server separate | Integrated in Dockerfile | ✅ Simpler deployment |
| Client built locally | Built in Docker | ✅ Consistent builds |
| Separate nginx service | Express serves static | ✅ Fewer containers |

## 🎯 Optional: Advanced Multi-Service Setup

If you want to keep API and Worker separate:

```bash
# 1. Deploy main service first (UI + core API)
# 2. Then add optional services:

railway service create --name feedback-api --dockerfile Dockerfile.api
railway service create --name feedback-worker --dockerfile Dockerfile.worker

# 3. Set service-specific variables in Railway
```

This gives you independent scaling for heavy workloads.

## 📚 Related Files

- `Dockerfile` - Main service (updated)
- `Dockerfile.api` - Optional API service (new)
- `Dockerfile.worker` - Optional worker service (new)
- `server/server.js` - Updated to serve client
- `railway.json` - Configuration (updated)
- `railway-services.toml` - Multi-service config (new)

## 🚀 Next Steps

1. **Commit the changes** (already done? Verify: `git status`)
2. **Push to GitHub** (already done? Verify: `git log`)
3. **Connect Railway** (via dashboard or CLI)
4. **Set environment variables** (critical!)
5. **Monitor deployment** (`railway logs -f`)
6. **Test your app** (visit the URL)

## ✅ Success Criteria

Your deployment is successful when:
- ✅ You can visit https://your-app.railway.app
- ✅ React UI loads
- ✅ Login works
- ✅ API calls work
- ✅ No errors in logs

---

**Status**: Ready to deploy! 🚀

Push your changes to GitHub and Railway will auto-deploy.
