$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"

$logPath = "C:\Program Files\Open Solutions Installation Information\DNA4\Log_$timestamp.txt"
$batchFile = "C:\temp\install_script.bat"

# Create the batch file content
$batchContent = @"
@echo off
Setup.exe /s /v"/l*v "%logPath%" ENVNAME="PROD, BKTEST001D" DMCONNECTSTRING="Data Source=10.219.149.7:1521/BKTest001D; User Id=DEPLOYMGR;Password=deploymgr" CLIENTONLY=FALSE /Quiet"
"@

# Write content to batch file
Set-Content -Path $batchFile -Value $batchContent

# Run the batch file through cmd and wait for completion
$process = Start-Process -FilePath "cmd.exe" -ArgumentList "/c $batchFile" -NoNewWindow -PassThru

# Wait for a maximum of 10 minutes (600 seconds)
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
