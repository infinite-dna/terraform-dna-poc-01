# Try to locate sqlplus.exe
$sqlplusPath = Get-Command sqlplus -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Source

if (-not $sqlplusPath) {
    Write-Host "sqlplus.exe not found in PATH."
    exit
}

Write-Host "Found sqlplus at: $sqlplusPath"

# Fetch the Oracle base path (one level up from the 'bin' folder)
$oracleBinPath = Split-Path $sqlplusPath -Parent
$oracleBasePath = Split-Path $oracleBinPath -Parent

Write-Host "Searching for Oracle.ManagedDataAccess.dll under: $oracleBasePath"

# Search for the DLL and stop when the first one is found
$targetFile = "Oracle.ManagedDataAccess.dll"
$found = $false

try {
    $result = Get-ChildItem -Path $oracleBasePath -Recurse -Filter $targetFile -File -Force -ErrorAction SilentlyContinue |
              Select-Object -First 1

    if ($result) {
        Write-Host "Found: $($result.FullName)"
        $found = $true
    }
} catch {
    Write-Host "Error during search: $_"
    exit 1
}

if (-not $found) {
    Write-Host "$targetFile not found under $oracleBasePath exiting the flow as dll to connect to database is not found"
    exit 1
}
