param (
    [string]$instanceName = "test",
    [string]$fp_appName = "test",
    [string]$fp_appVersion = "test",
    [string]$fp_appEnv = "test",
    [string]$fp_kekCertPath = "test",
    [string]$fp_certPassPhrase = "test",
    [string]$fp_defaultSharedSecret = "test"
)

# Ensure IIS WebAdministration module is loaded
try {
    Import-Module WebAdministration -ErrorAction Stop
} catch {
    Write-Error "IIS WebAdministration module not found. Ensure IIS Management Scripts and Tools are installed."
    exit 1
}

# Find the IIS site using -match for flexible pattern matching
$site = Get-Website | Where-Object { $_.Name -match "$instanceName.*-DNA" } | Select-Object -First 1

if (-not $site) {
    Write-Error "No IIS site found matching '$instanceName.*-DNA'. Check your instanceName."
    exit 1
}

# Resolve physical path
$sitePath = $site.PhysicalPath -replace '^%SystemDrive%', $env:SystemDrive

Write-Output "Matching Site Found: $($site.Name)"
Write-Output "Site Path: $sitePath"

# Verify voltagelib/config path
$configFilePath = Join-Path -Path $sitePath -ChildPath "voltagelib\config\abcconfig.cfg"

if (-not (Test-Path $configFilePath)) {
    Write-Error "Configuration file not found at: $configFilePath"
    exit 1
}

# Function to update a specific property in the config file
function Update-ConfigProperty {
    param (
        [string]$PropertyName,
        [string]$NewValue
    )
    (Get-Content $configFilePath) | ForEach-Object {
        if ($_ -match "^$PropertyName=") {
            "$PropertyName=$NewValue"
        } else {
            $_
        }
    } | Set-Content -Path $configFilePath -Encoding UTF8
}

# Update each property one by one
Update-ConfigProperty "fp_appName" $fp_appName
Update-ConfigProperty "fp_appVersion" $fp_appVersion
Update-ConfigProperty "fp_appEnv" $fp_appEnv
Update-ConfigProperty "fp_kekCertPath" $fp_kekCertPath
Update-ConfigProperty "fp_certPassPhrase" $fp_certPassPhrase
Update-ConfigProperty "fp_defaultSharedSecret" $fp_defaultSharedSecret

Write-Output "Configuration updated successfully at: $configFilePath"
