$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"

$logPath = "C:\Program Files\Open Solutions Installation Information\DNA4\Log_$timestamp.txt"

$arguments = @(
    "/s",
    "/v",
    "/l*v `"$logPath`"",
    "ENVNAME=`"PROD, BKTEST001D`"",
    "DMCONNECTSTRING=`"Data Source=10.219.149.7:1521/BKTest001D; User Id=DEPLOYMGR;Password=deploymgr`"",
    "CLIENTONLY=FALSE",
    "/Quiet"
)

$process = Start-Process -FilePath "Setup.exe" -ArgumentList $arguments -NoNewWindow -PassThru

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
