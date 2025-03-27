$setupPath = "C:\Path\To\Setup.exe"  # Replace with the actual full path

$arguments = '/s /v"/1*V \"C:\Program Files\Open Solutions Installation Information\DNA4\Log_1.txt\" ' +
'ENVNAME=\"PROD, BKTEST001D\" DMCONNECTSTRING=\"Data Source=10.219.149.7:1521/BKTest001D; ' +
'User Id=DEPLOYMGR;Password=deploymgr\" CLIENTONLY=FALSE /Quiet"'

$process = Start-Process -FilePath $setupPath -ArgumentList $arguments -NoNewWindow -PassThru

$process.WaitForExit()

if ($process.ExitCode -eq 0) {
    Write-Host "Setup completed successfully."
} else {
    Write-Host "Setup failed with exit code: $($process.ExitCode)"
}
