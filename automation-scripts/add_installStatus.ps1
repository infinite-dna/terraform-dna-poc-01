# Define the path to the INI file
$iniFilePath = "C:\dna\temp\runtimeconfig.ini"

# Function to read INI file as a hashtable
function Read-IniFile {
    param (
        [string]$Path
    )
    $iniContent = @{}
    Get-Content -Path $Path | ForEach-Object {
        if ($_ -match '^(?<key>[^=]+)=(?<value>.*)$') {
            $key = $matches['key'].Trim()
            $value = $matches['value'].Trim()
            $iniContent[$key] = $value
        }
    }
    return $iniContent
}

# Function to write hashtable back to the INI file
function Write-IniFile {
    param (
        [string]$Path,
        [hashtable]$Content
    )
    $contentArray = $Content.GetEnumerator() | ForEach-Object { "$($_.Key)=$($_.Value)" }
    $contentArray | Set-Content -Path $Path
}

# Read the INI file into a hashtable
if (-Not (Test-Path -Path $iniFilePath)) {
    Write-Host "INI file not found. Creating a new one."
    Set-Content -Path $iniFilePath -Value ""
}
$iniData = Read-IniFile -Path $iniFilePath

# Add or update the property 'isInstallationSuccessful' with default value 'false'
if (-Not $iniData.ContainsKey('isInstallationSuccessful')) {
    $iniData['isInstallationSuccessful'] = 'false'
} else {
    Write-Host "Property 'isInstallationSuccessful' already exists."
}

# Check a condition and update the value to 'true' if condition is met
if ($true) { # Replace $true with your actual condition
    $iniData['isInstallationSuccessful'] = 'true'
    Write-Host "Condition met. Updated 'isInstallationSuccessful' to 'true'."
}

# Write updated data back to the INI file
Write-IniFile -Path $iniFilePath -Content $iniData

Write-Host "Updated INI file:"
Get-Content -Path $iniFilePath
