#!/usr/bin/env pwsh
# Backend Wake-up Script for Render.com Service
# This script attempts to wake up the sleeping service

Write-Host "🔄 Attempting to wake up alumno-backend-node.onrender.com..." -ForegroundColor Yellow

$endpoints = @(
    "https://alumno-backend-node.onrender.com",
    "https://alumno-backend-node.onrender.com/health", 
    "https://alumno-backend-node.onrender.com/api",
    "https://alumno-backend-node.onrender.com/carnet",
    "https://alumno-backend-node.onrender.com/status"
)

foreach ($url in $endpoints) {
    Write-Host "🔍 Testing: $url" -ForegroundColor Cyan
    try {
        $response = Invoke-WebRequest -Uri $url -Method GET -TimeoutSec 30 -ErrorAction Stop
        Write-Host "✅ SUCCESS! Status: $($response.StatusCode)" -ForegroundColor Green
        Write-Host "Response: $($response.Content.Substring(0, [Math]::Min(200, $response.Content.Length)))" -ForegroundColor Green
        break
    }
    catch {
        $statusCode = $_.Exception.Response.StatusCode.value__
        if ($statusCode) {
            Write-Host "❌ Status: $statusCode" -ForegroundColor Red
        } else {
            Write-Host "❌ Connection failed: $($_.Exception.Message)" -ForegroundColor Red
        }
    }
    Start-Sleep -Seconds 2
}

Write-Host "`n⏰ Waiting 30 seconds for potential cold start..." -ForegroundColor Yellow
Start-Sleep -Seconds 30

# Test the actual endpoints
Write-Host "`n🎯 Testing actual carnet endpoints..." -ForegroundColor Magenta
$carnetUrls = @(
    "https://alumno-backend-node.onrender.com/carnet/15662",
    "https://alumno-backend-node.onrender.com/carnet/carnet:15662"
)

foreach ($url in $carnetUrls) {
    Write-Host "🔍 Testing carnet: $url" -ForegroundColor Cyan
    try {
        $response = Invoke-WebRequest -Uri $url -Method GET -TimeoutSec 30 -ErrorAction Stop
        Write-Host "✅ CARNET SUCCESS! Status: $($response.StatusCode)" -ForegroundColor Green
        Write-Host "Data: $($response.Content)" -ForegroundColor Green
    }
    catch {
        $statusCode = $_.Exception.Response.StatusCode.value__
        Write-Host "❌ Carnet Status: $statusCode" -ForegroundColor Red
    }
    Start-Sleep -Seconds 2
}

Write-Host "`n🏁 Wake-up attempt completed. Check Render.com dashboard for service status." -ForegroundColor Yellow