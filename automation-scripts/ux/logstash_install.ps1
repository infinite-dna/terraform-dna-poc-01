# Define function to check if a file exists
function Test-FileExists {
    param (
        [string]$Path
    )

    if (Test-Path -Path $Path) {
        return $true
    } else {
        return $false
    }
}

# Check if logstash-8.8.0 exists
$check = Test-FileExists -Path "C:\logstash\logstash.exe"

# Download logstash-8.8.0 if it doesn't exist
if (-not $check) {
    Invoke-WebRequest -Uri "https://artifactory.bank.onefiserv.net/artifactory/jenkins-support-tools/dna/pre-requisite-software/logstash-8.8.0-windows-x86_64.zip" -OutFile "C:\Temp\logstash-8.8.0-windows-x86_64.zip"
}

# Unzip logstash-8.8.0
Expand-Archive -Path "C:\Temp\logstash-8.8.0-windows-x86_64.zip" -DestinationPath "C:\Temp\logtemp"

# Copy extracted files to C:\logstash
Copy-Item -Path "C:\Temp\logtemp\logstash-8.8.0" -Destination "C:\logstash" -Recurse
