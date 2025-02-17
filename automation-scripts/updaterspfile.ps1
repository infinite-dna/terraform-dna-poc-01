param (
    [string]$rspFile = "C:\DNAConnect\temp\adminclient.rsp",
    [string]$iniFile = "C:\dnaconnect\temp\RuntimeConfig.ini"
)

# Check if files exist
if (-not (Test-Path $rspFile)) {
    Write-Host "Error: .rsp file not found at $rspFile"
    exit 1
}

if (-not (Test-Path $iniFile)) {
    Write-Host "Error: .ini file not found at $iniFile"
    exit 1
}

# Read oracle_path from runtimeconfig.ini
$oraclePath = Select-String -Path $iniFile -Pattern "^oracle_path\s*=\s*(.+)$" | ForEach-Object { $_.Matches.Groups[1].Value }

if (-not $oraclePath) {
    Write-Host "Error: oracle_path not found in $iniFile"
    exit 1
}

# Extract ORACLE_HOME and ORACLE_BASE values
$oracleHome = $oraclePath
$oracleBase = ($oraclePath -split "\\product")[0]  # Extracts path up to sysnt

# Update the .rsp file
(Get-Content $rspFile) -replace '^(ORACLE_HOME\s*=\s*).+', "`$1$oracleHome" `
                        -replace '^(ORACLE_BASE\s*=\s*).+', "`$1$oracleBase" | Set-Content $rspFile

# Set ORACLE_HOME as a system environment variable
[System.Environment]::SetEnvironmentVariable("ORACLE_HOME", $oracleHome, [System.EnvironmentVariableTarget]::Machine)

# Verify changes
Write-Host "Updated ORACLE_HOME in $rspFile to $oracleHome"
Write-Host "Updated ORACLE_BASE in $rspFile to $oracleBase"
Write-Host "Set system environment variable ORACLE_HOME to $oracleHome"
