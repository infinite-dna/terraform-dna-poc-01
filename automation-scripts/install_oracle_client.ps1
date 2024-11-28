# Define Variables
$oracleInstallerPath = "C:\OracleInstaller\setup.exe"  # Path to Oracle installer (update as per your environment)
$oracleBase = "C:\Oracle"
$oracleHome = "C:\Oracle\Product\19.0.0\Client_1"
$installType = "Custom"  # Options: "Administrator", "Runtime", "Custom"
$customComponents = @(
    "oracle.sqlplus:19.0.0.0.0",       # SQL*Plus
    "oracle.jdbc:19.0.0.0.0",          # JDBC/THIN Interfaces
    "oracle.ldap.client:19.0.0.0.0",   # Oracle Internet Directory Client
    "oracle.ntoledb.odp_net_2:19.0.0.0.0",  # Oracle Data Provider for .NET
    "oracle.aspnet2:19.0.0.0.0"        # Oracle Providers for ASP.NET
)

# Validate Oracle Installer Path
if (-not (Test-Path -Path $oracleInstallerPath)) {
    Write-Error "Oracle installer not found at $oracleInstallerPath. Please verify the path."
    exit 1
}

# Construct Command Line Arguments
$arguments = @(
    "-silent",
    "-responseFile", "NONE",  # No response file will be used
    "oracle.install.responseFileVersion=/oracle/install/rspfmt_clientinstall_response_schema_v19_0_0",
    "oracle.install.client.installType=$installType",
    "ORACLE_HOME=$oracleHome",
    "ORACLE_BASE=$oracleBase",
    "oracle.install.IsBuiltInAccount=true",
    "oracle.install.client.customComponents=""$($customComponents -join ",")"""
)

# Start Silent Installation
try {
    Write-Host "Starting Oracle Client installation without response file..."
    Start-Process -FilePath $oracleInstallerPath -ArgumentList $arguments -Wait -NoNewWindow
    Write-Host "Oracle Client installation completed successfully."
} catch {
    Write-Error "An error occurred during Oracle Client installation: $_"
}
