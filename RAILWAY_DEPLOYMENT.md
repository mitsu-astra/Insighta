# Railway Deployment Guide for Insighta

This guide will help you deploy the complete Insighta stack (Client, Server, Worker, and API) on Railway.

## Prerequisites

1. **Railway Account**: Sign up at [railway.app](https://railway.app)
2. **Git Repository**: Your Insighta project must be pushed to GitHub
3. **Required Environment Variables**: MongoDB URI, Redis connection details, API keys, etc.

## Architecture Overview

The Insighta deployment consists of:
- **Client**: React frontend (Nginx-served, Port 80)
- **Server**: Express backend (Port 4000)
- **Feedback Pipeline API**: AI feedback processing API (Port 3005)
- **Feedback Pipeline Worker**: Job worker for async processing (Port 3006)
- **MongoDB**: Database service
- **Redis**: Message queue and cache

## Step-by-Step Deployment

### 1. Connect to Railway

```bash
# Install Railway CLI
npm install -g @railway/cli

# Login to Railway
railway login

# Link your project
railway link
```

### 2. Set Up Services

#### Option A: Using Railway Dashboard (Recommended)

1. Go to [railway.app](https://railway.app)
2. Create a new project
3. Connect your GitHub repository (Insighta)
4. Railway will auto-detect the Dockerfile

#### Option B: Using Railway CLI

```bash
railway init
railway up
```

### 3. Configure Environment Variables

Set these in your Railway project settings:

#### Server Variables
```
PORT=4000
NODE_ENV=production
MONGO_URI=<your-mongodb-atlas-connection-string>
MONGO_DB=feedback_pipeline
JWT_SECRET=<your-secure-jwt-secret>
SMTP_USER=<your-email@gmail.com>
SMTP_PASS=<your-app-specific-password>
SENDER_EMAIL=<your-email@gmail.com>
CLIENT_URL=<your-railway-app-url>
REDIS_HOST=<redis-host>
REDIS_PORT=6379
REDIS_PASSWORD=<if-applicable>
```

#### Client Variables
```
VITE_API_URL=<your-server-url>
VITE_APP_NAME=AI CRM Feedback
```

#### Feedback Pipeline Variables
```
MONGO_URI=<your-mongodb-atlas-connection-string>
MONGO_DB=feedback_pipeline
REDIS_HOST=<redis-host>
REDIS_PORT=6379
REDIS_PASSWORD=<if-applicable>
AI_API_KEY=<your-huggingface-api-key>
AI_API_URL=https://api-inference.huggingface.co/models/cardiffnlp/twitter-roberta-base-sentiment-latest
WORKER_CONCURRENCY=5
JOB_TIMEOUT_MS=30000
MAX_RETRIES=3
API_PORT=3005
WORKER_METRICS_PORT=3006
```

### 4. Add Database Services

Railway supports integrating services. Add:

1. **MongoDB** (via Railway marketplace)
   - Copy the connection string to environment variables
   
2. **Redis** (via Railway marketplace)
   - Copy the connection details to environment variables

### 5. Deploy

Once environment variables are set:

```bash
# Deploy using Railway CLI
railway deploy

# Or push to your connected GitHub repo
git push origin main
```

## Project Structure for Deployment

```
Insighta/
├── Dockerfile                 # Root Dockerfile (orchestrates all services)
├── railway.json             # Railway configuration
├── railway.toml             # Alternative Railway config
├── .railwayignore           # Files to ignore in deployment
├── package.json             # Root package.json
├── start-all.js             # Multi-service startup script
├── client/
│   ├── Dockerfile           # Client Docker configuration
│   ├── package.json
│   └── ...
├── server/
│   ├── Dockerfile           # Server Docker configuration
│   ├── package.json
│   ├── server.js
│   └── config/
│       └── db.js            # MongoDB connection
├── feedback-pipeline/
│   ├── Dockerfile           # Worker/API Docker configuration
│   ├── package.json
│   ├── worker.js
│   └── api-server.js
└── monitoring/              # Optional: Monitoring stack
```

## Service Details

### Client Service
- **Framework**: React + Vite
- **Server**: Nginx
- **Port**: 80
- **Build Command**: `npm run build` (generates `/dist` folder)
- **Health Check**: Verifies `/index.html` accessibility

### Server Service
- **Framework**: Express.js
- **Database**: MongoDB (Mongoose)
- **Port**: 4000
- **Features**:
  - RESTful API endpoints
  - JWT authentication
  - Email notifications
  - Prometheus metrics
  - ELK logging integration

### Feedback Pipeline Services
- **Type**: Node.js with BullMQ
- **Components**:
  - **API** (Port 3005): REST endpoints for feedback submission
  - **Worker** (Port 3006): Async job processing with AI sentiment analysis
- **Queue**: Redis-backed BullMQ
- **AI Model**: Hugging Face (requires API key)

## Environment Variables Reference

### Critical for Production

| Variable | Description | Example |
|----------|-------------|---------|
| `MONGO_URI` | MongoDB Atlas connection | `mongodb+srv://user:pass@cluster.mongodb.net` |
| `REDIS_HOST` | Redis server hostname | Provided by Railway |
| `REDIS_PORT` | Redis server port | `6379` |
| `JWT_SECRET` | Encryption key for tokens | Generate: `openssl rand -base64 32` |
| `AI_API_KEY` | Hugging Face API key | Get from [hf.co/settings/tokens](https://hf.co/settings/tokens) |
| `CLIENT_URL` | Frontend URL | Your deployed app URL |

### Optional

| Variable | Description | Default |
|----------|-------------|---------|
| `NODE_ENV` | Environment mode | `production` |
| `WORKER_CONCURRENCY` | Parallel jobs | `5` |
| `JOB_TIMEOUT_MS` | Job timeout | `30000` |
| `MAX_RETRIES` | Failed job retries | `3` |

## Troubleshooting

### Services Not Starting

1. Check Railway logs:
   ```bash
   railway logs
   ```

2. Verify environment variables are set correctly

3. Check MongoDB connection:
   ```bash
   railway run npm run seed:admin
   ```

### Client Build Failures

- Ensure Node.js version >= 18
- Check `client/package.json` for missing dependencies
- Verify `vite.config.js` settings

### Redis Connection Issues

- Ensure `REDIS_HOST` and `REDIS_PORT` are correct
- If using Railway Redis, copy the connection string exactly
- Check firewall/network access

### MongoDB Connection Issues

- Whitelist Railway IP in MongoDB Atlas
- Verify credentials in `MONGO_URI`
- Ensure database name matches in `MONGO_DB`

## Post-Deployment

### Initialize Database

```bash
railway run cd server && npm run seed:admin
```

### Monitor Services

1. **Logs**: `railway logs` or Railway Dashboard
2. **Metrics**: Access Prometheus at `/metrics` endpoint
3. **Health Check**: Each service has built-in health checks

### Update Deployment

```bash
# Simple update
git push origin main

# Full redeploy
railway deploy
```

## Performance Optimization Tips

1. **Client**: Enable gzip compression (Nginx default)
2. **Server**: Use connection pooling for MongoDB
3. **Worker**: Adjust `WORKER_CONCURRENCY` based on load
4. **Cache**: Redis caching for frequently accessed data

## Security Checklist

- [ ] MongoDB Atlas IP whitelist configured
- [ ] JWT_SECRET is strong and random
- [ ] SMTP credentials use app-specific passwords
- [ ] Environment variables are encrypted
- [ ] Only essential ports are exposed
- [ ] CORS is properly configured in server

## Support & Additional Resources

- [Railway Documentation](https://docs.railway.app)
- [Railway CLI Reference](https://docs.railway.app/cli/commands)
- [MongoDB Atlas Setup](https://docs.atlas.mongodb.com)
- [Redis Guide](https://redis.io/documentation)

## Quick Start Commands

```bash
# Install Railway CLI
npm install -g @railway/cli

# Login
railway login

# Initialize project
railway init

# View logs
railway logs

# Deploy
railway deploy

# Run admin seed
railway run npm run seed:admin

# Check status
railway status
```

---

**Last Updated**: December 2024
**Supported Node Version**: >= 20.0.0
