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

# Get the IIS site path
$site = Get-Website | Where-Object { $_.Name -like "$instanceName*-DNA" } | Select-Object -First 1

if (-not $site) {
    Write-Error "No IIS site found matching '$instanceName*-DNA'"
    exit 1
}
else
{
# Resolve physical path
$sitePath = $site.PhysicalPath -replace '^%SystemDrive%', $env:SystemDrive

# Verify voltagelib/config path
$configFilePath = Join-Path -Path $sitePath -ChildPath "voltagelib\config\abcconfig.cfg"

if (-not (Test-Path $configFilePath)) {
    Write-Error "Configuration file not found at: $configFilePath"
    exit 1
}
else
{
# Read & update the configuration file
$updatedContent = Get-Content $configFilePath | ForEach-Object {
    $_ -replace '^fp_appName=.*$', "fp_appName=$fp_appName" `
       -replace '^fp_appVersion=.*$', "fp_appVersion=$fp_appVersion" `
       -replace '^fp_appEnv=.*$', "fp_appEnv=$fp_appEnv" `
       -replace '^fp_kekCertPath=.*$', "fp_kekCertPath=$fp_kekCertPath" `
       -replace '^fp_certPassPhrase=.*$', "fp_certPassPhrase=$fp_certPassPhrase" `
       -replace '^fp_defaultSharedSecret=.*$', "fp_defaultSharedSecret=$fp_defaultSharedSecret"
}

# Save changes
$updatedContent | Set-Content -Path $configFilePath -Encoding UTF8

Write-Output "Configuration updated successfully at: $configFilePath"
}
}
