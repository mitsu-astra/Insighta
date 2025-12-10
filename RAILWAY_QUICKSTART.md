# 🚀 Insighta to Railway - Quick Start (5 Minutes)

## TL;DR

```bash
# 1. Install Railway
npm install -g @railway/cli

# 2. Login
railway login

# 3. Initialize
railway init --name insighta

# 4. Set environment variables
railway variables set MONGO_URI "your-mongodb-uri"
railway variables set JWT_SECRET "your-secret"
railway variables set CLIENT_URL "https://your-app.railway.app"
# ... more variables

# 5. Deploy
git push origin main  # Or railway deploy
```

---

## Detailed Quick Start

### Prerequisites (2 min)

1. **Install Railway CLI:**
```bash
npm install -g @railway/cli
```

2. **Create Railway Account:**
   - Visit https://railway.app
   - Sign up with GitHub

3. **Install Git & Node:**
```bash
# Verify installations
git --version
node --version  # Must be >= 20
npm --version   # Must be >= 10
```

### Setup (3 min)

#### Step 1: Login to Railway
```bash
railway login
# Opens browser, authenticate with GitHub
```

#### Step 2: Initialize Project
```bash
railway init --name insighta
# Follow prompts
```

#### Step 3: Get MongoDB & Redis URLs

**Option A: Use Railway Plugins (Easiest)**
1. Go to Railway Dashboard
2. Click "Create"
3. Add "MongoDB" → copy connection string
4. Add "Redis" → copy connection string

**Option B: Use External Services**
1. MongoDB Atlas: Get connection string from https://cloud.mongodb.com
2. Redis: Get connection string from your Redis provider

#### Step 4: Generate Secrets

```bash
# Generate JWT Secret (on Linux/Mac)
openssl rand -base64 32

# Or use Node:
node -e "console.log(require('crypto').randomBytes(32).toString('base64'))"
```

#### Step 5: Set Environment Variables

```bash
# Core Variables
railway variables set MONGO_URI "mongodb+srv://..."
railway variables set JWT_SECRET "your-generated-secret"
railway variables set CLIENT_URL "https://insighta-xxxxx.railway.app"

# Redis
railway variables set REDIS_HOST "your-redis-host"
railway variables set REDIS_PORT "6379"

# Client
railway variables set VITE_API_URL "https://insighta-xxxxx.railway.app"

# AI & Email (Optional but recommended)
railway variables set AI_API_KEY "hf_your-huggingface-token"
railway variables set SMTP_USER "your-email@gmail.com"
railway variables set SMTP_PASS "your-app-password"
```

**View all variables:**
```bash
railway variables list
```

#### Step 6: Deploy

**Automatic (Recommended):**
```bash
# Commit and push
git add .
git commit -m "Railway deployment"
git push origin main
# Railway auto-deploys!
```

**Manual:**
```bash
railway deploy
```

#### Step 7: Monitor Deployment

```bash
# View logs
railway logs -f

# Check status
railway status

# Open app in browser
railway open
```

#### Step 8: Initialize Database

```bash
railway run npm run seed:admin
```

---

## Common Errors & Solutions

### Error: "MongoDB connection failed"
```
Solution:
1. Verify MONGO_URI is correct
2. Whitelist Railway IP in MongoDB Atlas:
   - Go to https://cloud.mongodb.com
   - Network Access → Add IP → Allow all (0.0.0.0/0)
3. Check credentials in connection string
```

### Error: "Redis connection refused"
```
Solution:
1. Check REDIS_HOST and REDIS_PORT
2. Verify Redis service is running
3. If using Railway Redis, ensure it's added
```

### Error: "Cannot find module"
```
Solution:
1. Check package.json has all dependencies
2. Verify Node version >= 20
3. Run: railway run npm install
```

### Error: "Build failed"
```
Solution:
1. Check Dockerfile syntax
2. Verify all required files exist
3. View build logs: railway logs --build
```

---

## Verification Checklist

After deployment, verify:

- [ ] App loads at your Railway URL
- [ ] Login works
- [ ] Can create feedback
- [ ] Worker is processing jobs
- [ ] No errors in logs (`railway logs`)
- [ ] Health endpoint works: `GET /api/public/stats`

---

## Architecture Overview

```
┌─────────────────────────────────────────────────────┐
│                   Railway.app                        │
├─────────────────────────────────────────────────────┤
│                                                       │
│  ┌──────────┐  ┌──────────┐  ┌──────────────────┐  │
│  │  Client  │  │  Server  │  │  Feedback        │  │
│  │ (React)  │  │ (Express)│  │  Pipeline        │  │
│  │ Port 80  │  │ Port 4000│  │ Ports 3005/3006  │  │
│  └──────────┘  └──────────┘  └──────────────────┘  │
│                                                       │
│  ┌──────────────────────────────────────────────┐   │
│  │         External Services                    │   │
│  │  • MongoDB (Database)                        │   │
│  │  • Redis (Queue & Cache)                     │   │
│  │  • Hugging Face (AI Sentiment)              │   │
│  │  • Gmail (Email)                             │   │
│  └──────────────────────────────────────────────┘   │
│                                                       │
└─────────────────────────────────────────────────────┘
```

---

## File Structure for Deployment

```
Insighta/
├── Dockerfile                    ← Root Docker config
├── railway.json                  ← Railway config
├── .railwayignore               ← Files to ignore
├── package.json                 ← Root dependencies
├── start-all.js                 ← Service orchestration
│
├── client/
│   ├── Dockerfile               ← Client image
│   ├── package.json
│   └── nginx.conf
│
├── server/
│   ├── Dockerfile               ← Server image
│   ├── package.json
│   └── server.js
│
└── feedback-pipeline/
    ├── Dockerfile               ← Worker image
    ├── package.json
    ├── worker.js
    └── api-server.js
```

---

## Environment Variables Reference

| Variable | Purpose | Example |
|----------|---------|---------|
| `MONGO_URI` | Database connection | `mongodb+srv://user:pass@cluster...` |
| `JWT_SECRET` | Auth token key | 32-char random string |
| `CLIENT_URL` | Frontend URL | `https://app.railway.app` |
| `REDIS_HOST` | Cache/Queue server | `redis.railway.app` |
| `REDIS_PORT` | Queue server port | `6379` |
| `AI_API_KEY` | AI/ML service token | `hf_xxxxx...` |
| `VITE_API_URL` | Backend endpoint | `https://app.railway.app` |
| `SMTP_USER` | Email sender | `your-email@gmail.com` |
| `SMTP_PASS` | Email app password | `16-char app password` |

---

## Next Steps

1. ✅ Deploy successfully
2. 📝 See `RAILWAY_DEPLOYMENT.md` for detailed documentation
3. ✔️ Use `DEPLOYMENT_CHECKLIST.md` for verification
4. 🔧 Configure monitoring & backups
5. 📊 Monitor application performance

---

## Support

- **Railway Docs:** https://docs.railway.app
- **CLI Guide:** https://docs.railway.app/cli/commands
- **Issues:** Check Railway Dashboard → Logs
- **Email Support:** support@railway.app

---

**Estimated Total Time:** 10-15 minutes including external service setup

Good luck! 🎉
