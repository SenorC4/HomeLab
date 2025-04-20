# Kill qBittorrent if running
$qbProcess = Get-Process -Name "qbittorrent" -ErrorAction SilentlyContinue
if ($qbProcess) {
    Write-Output "qBittorrent is running. Killing process..."
    $qbProcess | Stop-Process -Force
    Start-Sleep -Seconds 2  # brief pause to ensure it's fully closed
} else {
    Write-Output "qBittorrent is not currently running."
}


# Full path to piactl.exe
$piactlPath = "C:\Program Files\Private Internet Access\piactl.exe"

# Get the forwarded port
$port = & "$piactlPath" get portforward

# Trim whitespace
$port = $port.Trim()
# Ensure we got a valid port
if (-not ($port -match '^\d+$')) {
    Write-Error "Could not retrieve a valid port from piactl."
    exit 1
}

Write-Output "Got port $port from PIA."

# Path to qBittorrent config
$configPath = "$env:APPDATA\qBittorrent\qBittorrent.ini"

if (-Not (Test-Path $configPath)) {
    Write-Error "qBittorrent config not found at $configPath"
    exit 1
}

# Read the config
$config = Get-Content $configPath

# Update or add the port setting
$updated = $false
$config = $config | ForEach-Object {
    if ($_ -match 'Session\\Port=') {
        $updated = $true
        "Session\Port=$port"
        Write-Output "Updated qBittorrent.ini with port $port."
    } else {
        $_
    }
}

# If the setting wasn't found, add it
if (-not $updated) {
    $config += "Session\Port=$port"
}

# Write the updated config back
$config | Set-Content $configPath -Encoding UTF8



# Start qBittorrent
Start-Process -FilePath "C:\Program Files\qBittorrent\qbittorrent.exe"
Write-Output "qBittorrent started."
