param (
    [string]$exePath = "C:\DNA\Temp\voltage_hotfix.exe",
    [string]$extractPath = "C:\Voltage\Temp\Voltage",
    [string]$configFile = "C:\Voltage\Temp\runtimeconfig.ini"
)

# Create the extraction directory if it doesn't exist
if (!(Test-Path $extractPath)) {
    New-Item -ItemType Directory -Path $extractPath -Force | Out-Null
}

# Rename .exe to .zip
$zipPath = "$exePath.zip"
Copy-Item -Path $exePath -Destination $zipPath -Force

# Extract the ZIP file
try {
    Expand-Archive -Path $zipPath -DestinationPath $extractPath -Force
    Write-Host "Extraction successful."
} catch {
    Write-Host "ERROR: Extraction failed - $_"
    exit 1
}

# Find the single folder inside the extracted directory
$subFolders = Get-ChildItem -Path $extractPath -Directory
if ($subFolders.Count -eq 1) {
    $extractedFolder = $subFolders[0].FullName
    Write-Host "Found extracted folder: $extractedFolder"
    
    # Write to runtimeconfig.ini
    "voltagePath=$extractedFolder" | Set-Content -Path $configFile
    Write-Host "Config file updated at: $configFile"
} else {
    Write-Host "ERROR: Expected one folder, but found multiple or none."
    exit 1
}
