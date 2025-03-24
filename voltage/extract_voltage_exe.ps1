param (
    [string]$exePath = "C:\DNA\Temp\voltage_hotfix.exe",
    [string]$extractPath = "C:\Voltage\Temp\Voltage"
)

# Create log folder if not exists
$logFolder = "C:\Voltage\Logs"
if (!(Test-Path $logFolder)) {
    New-Item -ItemType Directory -Path $logFolder -Force
}

# Generate log file with timestamp
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$logFile = "$logFolder\exe_extract_$timestamp.log"

# Function to log messages to file and console
function Log-Message {
    param ([string]$message)
    $logEntry = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - $message"
    Write-Host $logEntry
    Add-Content -Path $logFile -Value $logEntry
}

# Log start
Log-Message "Starting extraction process."

# Ensure the target extraction folder exists
if (!(Test-Path $extractPath)) {
    Log-Message "Creating extraction folder: $extractPath"
    New-Item -ItemType Directory -Path $extractPath -Force | Out-Null
} else {
    Log-Message "Extraction folder already exists: $extractPath"
}

# Run the EXE with silent extraction
Log-Message "Running EXE: $exePath"
try {
    Start-Process -FilePath $exePath -ArgumentList "/extract:$extractPath /silent /norestart" -NoNewWindow -Wait
    Log-Message "Extraction completed successfully."
} catch {
    Log-Message "ERROR: Failed to execute EXE - $_"
}

# Log completion
Log-Message "Process finished. Log saved at $logFile"
