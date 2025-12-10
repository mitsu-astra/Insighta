# Railway Deployment Checklist for Insighta

## Pre-Deployment Checklist

### 1. Code Preparation
- [ ] All code is committed to Git
- [ ] `.gitignore` is properly configured (excludes node_modules, .env, build, dist)
- [ ] No hardcoded secrets in code
- [ ] All Dockerfiles are present and tested locally
- [ ] `package.json` files have proper scripts

### 2. Environment Configuration
- [ ] `.env.railway` file created and reviewed
- [ ] All required environment variables identified:
  - [ ] `MONGO_URI` (MongoDB Atlas connection string)
  - [ ] `JWT_SECRET` (strong random string)
  - [ ] `CLIENT_URL` (your Railway app URL)
  - [ ] `REDIS_HOST` and `REDIS_PORT` (from Railway Redis)
  - [ ] `AI_API_KEY` (Hugging Face token)
  - [ ] `VITE_API_URL` (backend URL)
- [ ] All optional variables reviewed and appropriate

### 3. External Services Setup
- [ ] MongoDB Atlas account created
  - [ ] Cluster created
  - [ ] Database user created
  - [ ] Connection string obtained
  - [ ] **Railway IPs whitelisted in Network Access**
- [ ] Hugging Face account created
  - [ ] API token generated
  - [ ] Model verified: `cardiffnlp/twitter-roberta-base-sentiment-latest`
- [ ] Gmail account setup (if using email)
  - [ ] 2-Factor Authentication enabled
  - [ ] App-specific password generated

### 4. Docker Configuration
- [ ] Root `Dockerfile` exists and works locally
- [ ] `client/Dockerfile` builds correctly
- [ ] `server/Dockerfile` builds correctly
- [ ] `feedback-pipeline/Dockerfile` builds correctly
- [ ] `nginx.conf` exists in client folder
- [ ] All Dockerfiles optimized for production

### 5. Railway Setup
- [ ] Railway account created at railway.app
- [ ] Railway CLI installed: `npm install -g @railway/cli`
- [ ] Connected to GitHub repository
- [ ] Project created in Railway Dashboard
- [ ] Services are properly configured

### 6. Database Preparation
- [ ] MongoDB collections structure verified
- [ ] Admin user seed script exists: `server/scripts/seedAdmin.js`
- [ ] Sample data scripts exist (if needed)
- [ ] Database migrations tested locally

### 7. Health Checks
- [ ] Server health endpoint working: `GET /api/public/stats`
- [ ] Client loads successfully
- [ ] Worker can connect to Redis and MongoDB
- [ ] API server responds to requests

## Deployment Steps

### Step 1: Install Railway CLI
```bash
npm install -g @railway/cli
railway login
```

### Step 2: Initialize Railway Project
```bash
railway init --name insighta
```

### Step 3: Add Services to Railway

**Via Dashboard:**
1. Go to Railway Dashboard
2. Select your project
3. Click "Add Service"
4. Select "GitHub"
5. Select your Insighta repository
6. Railway auto-detects Dockerfile

**Via CLI:**
```bash
railway link <PROJECT_ID>
```

### Step 4: Configure Environment Variables

Option A - Dashboard:
1. Go to project settings
2. Add each variable from `.env.railway`
3. Click "Save"

Option B - Railway CLI:
```bash
railway variables set MONGO_URI "mongodb+srv://..."
railway variables set JWT_SECRET "your-secret"
railway variables set CLIENT_URL "https://your-url.railway.app"
# ... repeat for all variables
```

### Step 5: Add External Services

**MongoDB (via Railway Plugins):**
1. In Railway Dashboard, click "Create"
2. Search "MongoDB"
3. Select "MongoDB"
4. Copy connection string
5. Set as `MONGO_URI` variable

**Redis (via Railway Plugins):**
1. In Railway Dashboard, click "Create"
2. Search "Redis"
3. Select "Redis"
4. Copy connection details
5. Set `REDIS_HOST` and `REDIS_PORT` variables

### Step 6: Deploy

**Automatic (GitHub Integration):**
- Push to main branch
- Railway automatically deploys

**Manual:**
```bash
railway deploy
```

### Step 7: Initialize Database

```bash
railway run npm run seed:admin
```

### Step 8: Verify Deployment

1. Check logs:
```bash
railway logs
```

2. Check services status:
```bash
railway status
```

3. Open application:
```bash
railway open
```

## Post-Deployment Verification

### Services Running
- [ ] Server running on port 4000
- [ ] Client accessible on port 80
- [ ] Feedback API running on port 3005
- [ ] Worker running on port 3006

### Health Checks
- [ ] Server health endpoint responds: `GET {SERVER_URL}/api/public/stats`
- [ ] Client homepage loads
- [ ] API accepts requests
- [ ] Worker processes jobs

### Database Connectivity
- [ ] MongoDB connection established
- [ ] Redis connection established
- [ ] Admin user created
- [ ] Can authenticate with credentials

### External Integrations
- [ ] Emails sending correctly
- [ ] AI sentiment analysis working
- [ ] Metrics endpoint responding

### Monitoring
- [ ] Prometheus metrics accessible: `{SERVER_URL}/metrics`
- [ ] Logs viewable in Railway Dashboard
- [ ] No errors in logs for 5 minutes

## Troubleshooting Guide

### Issue: Deployment Fails
**Check:**
1. Build logs: `railway logs --build`
2. Dockerfile syntax errors
3. Missing dependencies in package.json
4. Environment variables set correctly

### Issue: Services Not Starting
**Check:**
1. Service logs: `railway logs`
2. Port conflicts
3. Environment variable missing
4. External service connectivity (MongoDB, Redis)

### Issue: MongoDB Connection Error
**Check:**
1. `MONGO_URI` is correct
2. Railway IP is whitelisted in MongoDB Atlas
3. Database user credentials are valid
4. Cluster is not paused

### Issue: Redis Connection Error
**Check:**
1. `REDIS_HOST` and `REDIS_PORT` are correct
2. Redis service is running
3. Password is correct (if required)
4. Firewall rules allow connection

### Issue: Client Fails to Build
**Check:**
1. Node version >= 18
2. All npm dependencies installed
3. Build script in package.json exists
4. `nginx.conf` exists

### Issue: Worker Not Processing Jobs
**Check:**
1. Redis connection working
2. AI_API_KEY is valid
3. MongoDB connection working
4. Worker logs for errors

## Useful Commands

```bash
# View logs
railway logs

# Follow logs in real-time
railway logs -f

# View logs for specific service
railway logs --service server

# Check status
railway status

# Open dashboard
railway open

# Run commands
railway run npm run seed:admin

# Set environment variable
railway variables set KEY value

# List variables
railway variables list

# Download variables
railway variables download

# Get project info
railway project

# View domain
railway domains

# Connect to database
railway connect <database-name>
```

## Performance Optimization Tips

1. **Client**: Enable caching in nginx.conf
2. **Server**: Use MongoDB connection pooling
3. **Worker**: Adjust WORKER_CONCURRENCY based on load
4. **Redis**: Monitor memory usage
5. **Overall**: Use Railway resource monitoring

## Security Checklist

- [ ] JWT_SECRET is strong (32+ characters)
- [ ] SMTP_PASS uses app-specific password, not Gmail password
- [ ] No secrets in Git repository
- [ ] MongoDB requires authentication
- [ ] Redis requires password (if sensitive data)
- [ ] CORS properly configured
- [ ] HTTPS enforced
- [ ] Sensitive logs don't expose secrets

## Monitoring & Maintenance

### Daily
- Check logs for errors
- Monitor CPU/Memory usage

### Weekly
- Review user metrics
- Check job processing stats

### Monthly
- Review and rotate secrets if needed
- Update dependencies for security patches
- Backup database

---

**Last Updated**: December 2024
**Version**: 1.0.0
