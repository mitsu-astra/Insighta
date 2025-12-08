# CRM Sentiment Analysis - Stop All Services
# Run this script with: .\stop-all.ps1

Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  CRM Sentiment Analysis - Stopping All Services" -ForegroundColor Cyan
Write-Host "  (including ELK Stack)" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

# Stop Node processes
Write-Host "[1/5] Stopping Node.js processes..." -ForegroundColor Yellow
$nodeProcesses = Get-Process node -ErrorAction SilentlyContinue
if ($nodeProcesses) {
    $nodeProcesses | Stop-Process -Force -ErrorAction SilentlyContinue
    Write-Host "  Node processes stopped" -ForegroundColor Green
} else {
    Write-Host "  No Node processes found" -ForegroundColor Gray
}

# Stop PowerShell windows running services
Write-Host ""
Write-Host "[2/5] Stopping service windows..." -ForegroundColor Yellow
$serviceWindows = Get-Process powershell -ErrorAction SilentlyContinue | Where-Object { $_.MainWindowTitle -like "*npm*" }
if ($serviceWindows) {
    $serviceWindows | Stop-Process -Force -ErrorAction SilentlyContinue
    Write-Host "  Service windows closed" -ForegroundColor Green
} else {
    Write-Host "  No service windows found" -ForegroundColor Gray
}

# Stop ELK Stack containers
Write-Host ""
Write-Host "[3/5] Stopping ELK Stack..." -ForegroundColor Yellow
try {
    docker stop crm_elasticsearch crm_logstash crm_kibana crm_filebeat 2>$null
    Write-Host "  ELK Stack containers stopped" -ForegroundColor Green
} catch {
    Write-Host "  WARNING: Some ELK containers already stopped or Docker not running" -ForegroundColor Yellow
}

# Stop Docker containers
Write-Host ""
Write-Host "[4/5] Stopping other Docker containers..." -ForegroundColor Yellow
try {
    docker stop crm_prometheus crm_grafana redis-local 2>$null
    Write-Host "  Docker containers stopped" -ForegroundColor Green
} catch {
    Write-Host "  WARNING: Some containers already stopped or Docker not running" -ForegroundColor Yellow
}

# Docker Compose down for monitoring
Write-Host ""
Write-Host "[5/5] Stopping Docker Compose services..." -ForegroundColor Yellow
try {
    $monitoringPath = "$PSScriptRoot\monitoring"
    if (Test-Path $monitoringPath) {
        Push-Location $monitoringPath
        docker-compose stop 2>$null
        Pop-Location
        Write-Host "  All monitoring services stopped" -ForegroundColor Green
    }
} catch {
    Write-Host "  WARNING: Docker Compose services already stopped" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  All Services Stopped!" -ForegroundColor Green
Write-Host "================================================" -ForegroundColor Cyan
