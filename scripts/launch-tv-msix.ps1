# Launch TradingView MSIX with CDP debug port
# Run as Administrator

param([int]$Port = 9222)

$pkgName = "TradingView.Desktop_3.1.0.7818_x64__n534cwy3pjxzj"
$tvExe   = "C:\Program Files\WindowsApps\$pkgName\TradingView.exe"

Write-Host "=== TradingView MSIX Launcher ===" -ForegroundColor Cyan

# Step 1: Grant read access to exe (requires Admin)
Write-Host "[1/4] Granting access to WindowsApps folder..." -ForegroundColor Yellow
try {
    $acl = Get-Acl $tvExe -ErrorAction Stop
    Write-Host "      Access OK" -ForegroundColor Green
} catch {
    Write-Host "      Access denied — taking ownership..." -ForegroundColor Yellow
    $folder = "C:\Program Files\WindowsApps\$pkgName"
    takeown /f $folder /r /d y 2>$null | Out-Null
    icacls $folder /grant "Administrators:(OI)(CI)F" /t /q 2>$null | Out-Null
    Write-Host "      Done" -ForegroundColor Green
}

# Step 2: Verify exe exists
Write-Host "[2/4] Checking exe..." -ForegroundColor Yellow
if (-not (Test-Path $tvExe)) {
    # Try wildcard search inside package
    $found = Get-ChildItem "C:\Program Files\WindowsApps\$pkgName" -Filter "*.exe" -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($found) {
        $tvExe = $found.FullName
        Write-Host "      Found: $tvExe" -ForegroundColor Green
    } else {
        Write-Host "ERROR: TradingView.exe not found at $tvExe" -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "      Found: $tvExe" -ForegroundColor Green
}

# Step 3: Kill existing instances
Write-Host "[3/4] Stopping existing TradingView..." -ForegroundColor Yellow
Get-Process -Name "TradingView" -ErrorAction SilentlyContinue | Stop-Process -Force
Start-Sleep -Seconds 2
Write-Host "      Done" -ForegroundColor Green

# Step 4: Launch with CDP
Write-Host "[4/4] Launching with --remote-debugging-port=$Port ..." -ForegroundColor Yellow
Start-Process -FilePath $tvExe -ArgumentList "--remote-debugging-port=$Port"
Write-Host "      Launched! Waiting for CDP..." -ForegroundColor Green

# Wait for CDP to become available
$ready = $false
for ($i = 0; $i -lt 15; $i++) {
    Start-Sleep -Seconds 2
    try {
        $r = Invoke-WebRequest "http://localhost:$Port/json/version" -UseBasicParsing -TimeoutSec 2 -ErrorAction Stop
        Write-Host "`nCDP ready at http://localhost:$Port" -ForegroundColor Green
        Write-Host $r.Content
        $ready = $true
        break
    } catch {
        Write-Host "  Still waiting ($($i*2+2)s)..." -ForegroundColor Gray
    }
}

if (-not $ready) {
    Write-Host "`nCDP not responding after 30s." -ForegroundColor Red
    Write-Host "Try opening http://localhost:$Port in browser to check." -ForegroundColor Yellow
}
