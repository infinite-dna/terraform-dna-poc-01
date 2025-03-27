# Define variables
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$logPath = "C:\Program Files\Open Solutions Installation Information\DNA4\Log_$timestamp.txt"
$batchFile = "$env:TEMP\setup_install.bat"

# Define batch variables (ensuring proper escaping for batch script)
$envName = "PROD, BKTEST001D"
$dbConnect = "Data Source=10.219.149.7:1521/BKTest001D; User Id=DEPLOYMGR;Password=deploymgr"

# Construct the exact command (with actual values)
$setupCommand = "Setup.exe /s /v`"/l*v `"$logPath`" ENVNAME=`"$envName`" DMCONNECTSTRING=`"$dbConnect`" CLIENTONLY=FALSE /Quiet`""

# Create batch file content with actual values
$batchContent = @"
@echo off
echo Running Setup Command:
echo $setupCommand
$setupCommand
"@

# Write batch file with actual values
$batchContent | Set-Content -Path $batchFile -Encoding ASCII

# Display the exact command before execution
Write-Output "Executing batch file with the following command:"
Write-Output $setupCommand

# Run the batch file and wait for completion (timeout 10 minutes)
$process = Start-Process -FilePath "cmd.exe" -ArgumentList "/c `"$batchFile`"" -NoNewWindow -PassThru
$process | Wait-Process -Timeout 600

# Check if setup completed and display log
if ($process.HasExited) {
    if ($process.ExitCode -eq 0) {
        Write-Output "Setup completed successfully."
    } else {
        Write-Output "Setup failed with exit code: $($process.ExitCode)"
    }

    # Display log if it exists
    if (Test-Path $logPath) {
        Write-Output "Installation Log:"
        Get-Content $logPath -Raw
    } else {
        Write-Output "Log file not found: $logPath"
    }
} else {
    Write-Output "Setup did not complete within 10 minutes. Terminating process..."
    Stop-Process -Id $process.Id -Force
}
