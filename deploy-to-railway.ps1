#!/usr/bin/env pwsh
<#
.SYNOPSIS
Railway Deployment Script for Insighta
.DESCRIPTION
Automates the deployment setup for Railway
.EXAMPLE
.\deploy-to-railway.ps1
#>

Write-Host "🚀 Insighta Railway Deployment Setup" -ForegroundColor Cyan
Write-Host "======================================`n" -ForegroundColor Cyan

# Check if Railway CLI is installed
Write-Host "📋 Checking prerequisites..." -ForegroundColor Yellow

$railwayInstalled = (npm list -g @railway/cli) -match "@railway/cli"
if (-not $railwayInstalled) {
    Write-Host "❌ Railway CLI not found. Installing..." -ForegroundColor Red
    npm install -g @railway/cli
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Failed to install Railway CLI" -ForegroundColor Red
        exit 1
    }
}
Write-Host "✅ Railway CLI is installed`n" -ForegroundColor Green

# Check if git is initialized
if (-not (Test-Path ".git")) {
    Write-Host "⚠️  Git repository not initialized" -ForegroundColor Yellow
    $gitInit = Read-Host "Initialize git? (y/n)"
    if ($gitInit -eq "y") {
        git init
        git add .
        git commit -m "Initial commit for Railway deployment"
    }
}

# Login to Railway
Write-Host "🔐 Authenticating with Railway..." -ForegroundColor Yellow
railway login
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Failed to login to Railway" -ForegroundColor Red
    exit 1
}
Write-Host "✅ Successfully logged in to Railway`n" -ForegroundColor Green

# Initialize Railway project
Write-Host "⚙️  Initializing Railway project..." -ForegroundColor Yellow
$projectName = Read-Host "Enter project name (default: insighta)"
if (-not $projectName) { $projectName = "insighta" }

railway init --name $projectName
Write-Host "✅ Railway project initialized`n" -ForegroundColor Green

# Display environment variables template
Write-Host "📝 Environment Variables Required" -ForegroundColor Cyan
Write-Host "====================================`n" -ForegroundColor Cyan

Write-Host "Please set these environment variables in Railway Dashboard:`n" -ForegroundColor Yellow

Write-Host "Server Variables:" -ForegroundColor Green
$serverVars = @(
    "MONGO_URI=mongodb+srv://username:password@cluster.mongodb.net",
    "JWT_SECRET=<generate-random-string>",
    "CLIENT_URL=https://your-app-url.railway.app",
    "REDIS_HOST=<railway-redis-host>",
    "REDIS_PORT=6379",
    "NODE_ENV=production",
    "PORT=4000"
)
$serverVars | ForEach-Object { Write-Host "  $_" }

Write-Host "`nClient Variables:" -ForegroundColor Green
$clientVars = @(
    "VITE_API_URL=https://your-api-url.railway.app",
    "VITE_APP_NAME=AI CRM Feedback"
)
$clientVars | ForEach-Object { Write-Host "  $_" }

Write-Host "`nFeedback Pipeline Variables:" -ForegroundColor Green
$workerVars = @(
    "MONGO_URI=mongodb+srv://username:password@cluster.mongodb.net",
    "MONGO_DB=feedback_pipeline",
    "REDIS_HOST=<railway-redis-host>",
    "REDIS_PORT=6379",
    "AI_API_KEY=<huggingface-api-key>",
    "WORKER_CONCURRENCY=5",
    "API_PORT=3005",
    "WORKER_METRICS_PORT=3006"
)
$workerVars | ForEach-Object { Write-Host "  $_" }

# Display next steps
Write-Host "`n📋 Next Steps:" -ForegroundColor Cyan
Write-Host "====================================`n" -ForegroundColor Cyan

Write-Host "1. Set environment variables:" -ForegroundColor Green
Write-Host "   railway variables set <KEY> <VALUE>`n"

Write-Host "2. Push to GitHub:" -ForegroundColor Green
Write-Host "   git add ." -ForegroundColor DarkGray
Write-Host "   git commit -m 'Setup Railway deployment'" -ForegroundColor DarkGray
Write-Host "   git push origin main`n" -ForegroundColor DarkGray

Write-Host "3. Monitor deployment:" -ForegroundColor Green
Write-Host "   railway logs`n"

Write-Host "4. View project:" -ForegroundColor Green
Write-Host "   railway open`n"

Write-Host "5. Initialize database:" -ForegroundColor Green
Write-Host "   railway run npm run seed:admin`n"

Write-Host "✅ Setup complete! Your project is ready for Railway deployment." -ForegroundColor Green
Write-Host "`n📖 For more info, see: RAILWAY_DEPLOYMENT.md" -ForegroundColor Cyan
