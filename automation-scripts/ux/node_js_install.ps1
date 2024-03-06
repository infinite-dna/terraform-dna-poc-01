# Define function to check if a directory exists
function Test-DirectoryExists {
    param (
        [string]$Path
    )

    if (Test-Path -Path $Path -PathType Container) {
        return $true
    } else {
        return $false
    }
}

# Check if NodeJS exists
$check = Test-DirectoryExists -Path "C:\Program Files\nodejs"

# Download NodeJS if it doesn't exist
if (-not $check) {
    Invoke-WebRequest -Uri "https://artifactory.bank.onefiserv.net/artifactory/jenkins-support-tools/dna/pre-requisite-software/node-v18.16.0-x64.msi" -OutFile "C:\Temp\node-v18.16.0-x64.msi"
}

# Install NodeJS if it has been downloaded
if (-not $check -and Test-Path -Path "C:\Temp\node-v18.16.0-x64.msi") {
    Start-Process -FilePath "msiexec.exe" -ArgumentList "/i", "C:\Temp\node-v18.16.0-x64.msi", "/quiet", "/passive" -Wait
}
