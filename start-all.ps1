# CRM Sentiment Analysis - Full Stack Startup Script
# Run this script with: .\start-all.ps1

Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  CRM Sentiment Analysis - Starting All Services" -ForegroundColor Cyan
Write-Host "  (with ELK Stack Integration)" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

# Install dependencies for all modules
Write-Host "[1/10] Installing Node Dependencies..." -ForegroundColor Yellow

# Server dependencies
Write-Host "  Installing server dependencies..." -ForegroundColor Cyan
Push-Location "$PSScriptRoot\server"
npm install 2>&1 | Out-Null
if ($LASTEXITCODE -eq 0) {
    Write-Host "    Server dependencies installed" -ForegroundColor Green
} else {
    Write-Host "    WARNING: Server dependencies installation had issues" -ForegroundColor Yellow
}
Pop-Location

# Client dependencies
Write-Host "  Installing client dependencies..." -ForegroundColor Cyan
Push-Location "$PSScriptRoot\client"
npm install 2>&1 | Out-Null
if ($LASTEXITCODE -eq 0) {
    Write-Host "    Client dependencies installed" -ForegroundColor Green
} else {
    Write-Host "    WARNING: Client dependencies installation had issues" -ForegroundColor Yellow
}
Pop-Location

# Feedback pipeline dependencies
Write-Host "  Installing feedback-pipeline dependencies..." -ForegroundColor Cyan
Push-Location "$PSScriptRoot\feedback-pipeline"
npm install 2>&1 | Out-Null
if ($LASTEXITCODE -eq 0) {
    Write-Host "    Feedback-pipeline dependencies installed" -ForegroundColor Green
} else {
    Write-Host "    WARNING: Feedback-pipeline dependencies installation had issues" -ForegroundColor Yellow
}
Pop-Location

# Create log directories for ELK
Write-Host ""
Write-Host "[2/10] Creating log directories..." -ForegroundColor Yellow
$logDirs = @(
    "$PSScriptRoot\server\logs",
    "$PSScriptRoot\feedback-pipeline\logs"
)
foreach ($dir in $logDirs) {
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
        Write-Host "  Created: $dir" -ForegroundColor Green
    }
}
Write-Host "  Log directories ready" -ForegroundColor Green

# Check if Docker is running
Write-Host ""
Write-Host "[3/10] Checking Docker Desktop..." -ForegroundColor Yellow
$dockerCheck = $false
try {
    docker info 2>&1 | Out-Null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  Docker is running" -ForegroundColor Green
        $dockerCheck = $true
    }
}
catch {
    $dockerCheck = $false
}

if ($dockerCheck -eq $false) {
    Write-Host "  Docker not running, starting Docker Desktop..." -ForegroundColor Yellow
    try {
        Start-Process "C:\Program Files\Docker\Docker\Docker Desktop.exe" -WindowStyle Hidden
        Write-Host "  Waiting 15 seconds for Docker to initialize..." -ForegroundColor Yellow
        Start-Sleep -Seconds 15
        Write-Host "  Docker Desktop started" -ForegroundColor Green
    }
    catch {
        Write-Host "  Could not start Docker Desktop automatically" -ForegroundColor Yellow
        Write-Host "  Please start it manually from your programs menu and try again" -ForegroundColor Yellow
    }
}

# Start ELK Stack (Elasticsearch, Logstash, Kibana)
Write-Host ""
Write-Host "[4/10] Starting ELK Stack..." -ForegroundColor Yellow
try {
    Push-Location "$PSScriptRoot\monitoring"
    
    Write-Host "  Starting Elasticsearch..." -ForegroundColor Cyan
    docker-compose up -d elasticsearch 2>&1 | Out-Null
    
    Write-Host "  Starting Logstash..." -ForegroundColor Cyan
    docker-compose up -d logstash 2>&1 | Out-Null
    
    Write-Host "  Starting Kibana..." -ForegroundColor Cyan
    docker-compose up -d kibana 2>&1 | Out-Null
    
    Write-Host "  Starting Filebeat..." -ForegroundColor Cyan
    docker-compose up -d filebeat 2>&1 | Out-Null
# Start Prometheus and Grafana
Write-Host ""
Write-Host "[6/10] Starting Prometheus and Grafana..." -ForegroundColor Yellow
    Write-Host "    Elasticsearch: http://localhost:9200" -ForegroundColor DarkGray
    Write-Host "    Kibana:        http://localhost:5601" -ForegroundColor DarkGray
}
catch {
    Write-Host "  ELK Stack startup skipped" -ForegroundColor Yellow
}

# Start Redis (if not already running)
Write-Host ""
Write-Host "[5/10] Starting Redis..." -ForegroundColor Yellow
try {
    $redisRunning = docker ps --filter "name=redis" --format "{{.Names}}" 2>&1 | Select-String "redis"
    if (-not $redisRunning) {
        docker run -d --name redis-local -p 6379:6379 redis:alpine 2>&1 | Out-Null
        if ($LASTEXITCODE -ne 0) {
            docker start redis-local 2>&1 | Out-Null
        }
    }
    Write-Host "  Redis running on port 6379" -ForegroundColor Green
}
catch {
    Write-Host "  Redis startup skipped" -ForegroundColor Yellow
}

# Start Prometheus and Grafana
Write-Host ""
Write-Host "[4/8] Starting Prometheus and Grafana..." -ForegroundColor Yellow
try {
    Push-Location "$PSScriptRoot\monitoring"
    docker-compose up -d prometheus grafana 2>&1 | Out-Null
    Pop-Location
    Write-Host "  Prometheus running on http://localhost:9090" -ForegroundColor Green
    Write-Host "  Grafana running on http://localhost:3001" -ForegroundColor Green
    Write-Host "    Login: team.808.test@gmail.com / team@808" -ForegroundColor DarkGray
}
catch {
    Write-Host "  Docker Compose services skipped" -ForegroundColor Yellow
}

# Start Backend Server
Write-Host ""
Write-Host "[7/10] Starting Backend Server..." -ForegroundColor Yellow
try {
    $serverCmd = "cd '$PSScriptRoot\server'; npm start"
    Start-Process powershell -ArgumentList "-NoExit", "-Command", $serverCmd
    Write-Host "  Backend starting on http://localhost:4000" -ForegroundColor Green
    Write-Host "  Metrics at http://localhost:4000/metrics" -ForegroundColor DarkGray
}
catch {
    Write-Host "  ERROR: Failed to start backend server" -ForegroundColor Red
    Write-Host "  $_" -ForegroundColor Red
}

# Wait briefly
Start-Sleep -Seconds 2

# Start Frontend
Write-Host ""
Write-Host "[8/10] Starting Frontend..." -ForegroundColor Yellow
try {
    $clientCmd = "cd '$PSScriptRoot\client'; npm run dev"
    Start-Process powershell -ArgumentList "-NoExit", "-Command", $clientCmd
    Write-Host "  Frontend starting on http://localhost:3000" -ForegroundColor Green
}
catch {
    Write-Host "  ERROR: Failed to start frontend" -ForegroundColor Red
    Write-Host "  $_" -ForegroundColor Red
}

# Wait a moment for services to start
Start-Sleep -Seconds 3

# Check ELK Stack health
Write-Host ""
Write-Host "[9/10] Checking ELK Stack health..." -ForegroundColor Yellow
$elkReady = $true
try {
    $esResponse = Invoke-WebRequest -Uri "http://localhost:9200/_cluster/health" -UseBasicParsing -TimeoutSec 2 -ErrorAction SilentlyContinue
    if ($esResponse.StatusCode -eq 200) {
        Write-Host "  Elasticsearch: Ready" -ForegroundColor Green
    }
} catch {
    Write-Host "  Elasticsearch: Starting... (may take 1-2 minutes)" -ForegroundColor Yellow
    $elkReady = $false
}

Write-Host ""
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  All Services Started!" -ForegroundColor Green
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Application:" -ForegroundColor Yellow
Write-Host "  Frontend:    http://localhost:3000" -ForegroundColor White
Write-Host "  Backend:     http://localhost:4000" -ForegroundColor White
Write-Host ""
Write-Host "Monitoring & Analytics:" -ForegroundColor Yellow
Write-Host "  Grafana:         http://localhost:3001" -ForegroundColor White
Write-Host "  Prometheus:      http://localhost:9090" -ForegroundColor White
Write-Host "  Kibana (ELK):    http://localhost:5601" -ForegroundColor Cyan
Write-Host "  Elasticsearch:   http://localhost:9200" -ForegroundColor Cyan
Write-Host ""
Write-Host "  Admin Login:" -ForegroundColor Yellow
Write-Host "    Email:    team.808.test@gmail.com" -ForegroundColor White
Write-Host "    Password: team@808" -ForegroundColor White
Write-Host ""
if (-not $elkReady) {
    Write-Host "Note: ELK Stack is starting in background. Wait 1-2 minutes before accessing Kibana." -ForegroundColor Yellow
    Write-Host "      Create index patterns in Kibana: crm-logs-*, crm-errors-*, crm-auth-*" -ForegroundColor Yellow
    Write-Host ""
}

# Open browser
Write-Host "[10/10] Opening in browser..." -ForegroundColor Yellow
try {
    Start-Process "http://localhost:3000"
    Write-Host "  Browser opened" -ForegroundColor Green
}
catch {
    Write-Host "  Could not open browser automatically" -ForegroundColor Yellow
}
