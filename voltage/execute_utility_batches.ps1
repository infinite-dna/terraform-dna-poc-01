# Define variables
$xmlPath = "initialdataencryption\resource\InitiaDataEncryptionField.xml"
$exePath = "./../initialDataEncryption.exe"
$utilityFolder = "initialdataencryption\utility_cmd"
$dbConnection = "dbserver:port/dbname"
$username = "osibank"
$password = "osibank"
$passnumber = 1

# Create the utility_cmd folder if it doesn't exist
if (!(Test-Path -Path $utilityFolder)) {
    New-Item -ItemType Directory -Path $utilityFolder | Out-Null
    Write-Host "Created folder: $utilityFolder"
}

# Load the XML file
[xml]$xmlContent = Get-Content -Path $xmlPath

# List to store batch file paths (ensuring order is maintained)
$batchFiles = @()

# Read FIELDGROUP names and create batch files in XML order
Write-Host "`n==> Creating batch files in order:" -ForegroundColor Yellow
foreach ($fieldGroup in $xmlContent.XML.FIELDGROUPS.FIELDGROUP) {
    $fieldGroupName = $fieldGroup.NAME
    $batchFileName = "$utilityFolder\$fieldGroupName`_$passnumber.bat"
    $batchContent = "$exePath $dbConnection $username $password $passnumber $fieldGroupName"

    # Create the batch file with content
    Set-Content -Path $batchFileName -Value $batchContent
    Write-Host "   - $batchFileName" -ForegroundColor Cyan

    # Add to list to ensure execution order follows XML
    $batchFiles += $batchFileName
}

# Display execution order before starting
Write-Host "`n==> Execution order verification:" -ForegroundColor Yellow
foreach ($batchFile in $batchFiles) {
    Write-Host "   -> Will execute: $batchFile" -ForegroundColor Cyan
}

# Execute batch files in the same order as in XML, capturing output
Write-Host "`n==> Executing batch files in order with verbose logs..." -ForegroundColor Green
foreach ($batchFile in $batchFiles) {
    Write-Host "`nExecuting: $batchFile" -ForegroundColor Magenta

    # Capture batch file output in real-time
    $process = Start-Process -FilePath "cmd.exe" `
        -ArgumentList "/c `"$batchFile`"" `
        -NoNewWindow `
        -Wait `
        -PassThru `
        -RedirectStandardOutput "$batchFile.log" `
        -RedirectStandardError "$batchFile.err"

    # Print the log file contents after execution
    if (Test-Path "$batchFile.log") {
        Write-Host "`n[LOG OUTPUT for $batchFile]" -ForegroundColor Cyan
        Get-Content "$batchFile.log" | ForEach-Object { Write-Host $_ }
    }
    
    if (Test-Path "$batchFile.err") {
        Write-Host "`n[ERROR LOG for $batchFile]" -ForegroundColor Red
        Get-Content "$batchFile.err" | ForEach-Object { Write-Host $_ }
    }

    # Check exit code and log result
    if ($process.ExitCode -eq 0) {
        Write-Host "✔ Execution successful: $batchFile" -ForegroundColor Green
    } else {
        Write-Host "❌ Execution failed: $batchFile with exit code $($process.ExitCode)" -ForegroundColor Red
        exit 1  # Stop execution if any batch file fails
    }
}

Write-Host "`n🎉 All batch files executed successfully in XML-defined order!" -ForegroundColor Green
