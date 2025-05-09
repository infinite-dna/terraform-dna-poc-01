$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"

$logPath = "C:\Program Files\Open Solutions Installation Information\DNA4\Log_$timestamp.txt"

$cmdCommand = "Setup.exe /s /v\"/l*v \"$logPath\" ENVNAME=\"PROD, BKTEST001D\" DMCONNECTSTRING=\"Data Source=10.219.149.7:1521/BKTest001D; User Id=DEPLOYMGR;Password=deploymgr\" CLIENTONLY=FALSE /Quiet\""

$process = Start-Process -FilePath "cmd.exe" -ArgumentList "/c $cmdCommand" -NoNewWindow -PassThru

# Wait for a maximum of 10 minutes (600000 ms)
$process | Wait-Process -Timeout 600

if ($process.HasExited) {
    if ($process.ExitCode -eq 0) {
        Write-Output "Setup completed successfully."
    } else {
        Write-Output "Setup failed with exit code: $($process.ExitCode)"
    }
} else {
    Write-Output "Setup did not complete within 10 minutes. Terminating process..."
    Stop-Process -Id $process.Id -Force
}

# Display log contents if the log file exists
if (Test-Path $logPath) {
    Write-Output "Setup Log Contents:"
    Get-Content $logPath | ForEach-Object { Write-Output $_ }
} else {
    Write-Output "Log file not found: $logPath"
}
