# Define Variables
$oracleInstallerPath = "C:\OracleInstaller\setup.exe"  # Path to Oracle installer
$oracleHome = "C:\Oracle\Product\19.0.0\Client_1"      # Target Oracle Home directory
$oracleBase = "C:\Oracle"                             # Oracle Base directory
$installType = "Custom"                               # Installation type (e.g., Administrator, Runtime, Custom)
$customComponents = @(
    "oracle.sqlplus:19.0.0.0.0",       # SQL*Plus
    "oracle.jdbc:19.0.0.0.0",          # JDBC/THIN Interfaces
    "oracle.ldap.client:19.0.0.0.0",   # Oracle Internet Directory Client
    "oracle.ntoledb.odp_net_2:19.0.0.0.0",  # Oracle Data Provider for .NET
    "oracle.aspnet2:19.0.0.0.0"        # Oracle Providers for ASP.NET
)

# Ensure the Oracle Installer Exists
if (-not (Test-Path -Path $oracleInstallerPath)) {
    Write-Error "Oracle installer not found at $oracleInstallerPath. Please verify the path."
    exit 1
}

# Build Command Arguments
$arguments = @(
    "-silent",
    "-responseFile", "NONE",  # Indicates no response file is being used
    "oracle.install.responseFileVersion=/oracle/install/rspfmt_clientinstall_response_schema_v19_0_0",
    "oracle.install.client.installType=$installType",
    "ORACLE_HOME=$oracleHome",
    "ORACLE_BASE=$oracleBase",
    "oracle.install.IsBuiltInAccount=true",
    "oracle.install.client.customComponents=""$($customComponents -join ",")"""
)

# Log Arguments (Optional Debugging)
Write-Host "Command-line Arguments:"
$arguments | ForEach-Object { Write-Host $_ }

# Start Installation Process
try {
    Write-Host "Starting Oracle Client installation in silent mode..."
    Start-Process -FilePath $oracleInstallerPath -ArgumentList $arguments -Wait -NoNewWindow
    Write-Host "Oracle Client installation completed successfully."
} catch {
    Write-Error "An error occurred during Oracle Client installation: $_"
}
