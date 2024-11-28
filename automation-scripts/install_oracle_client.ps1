# Define Variables
$responseFilePath = "C:\temp\client_install.rsp"  # Path to save the response file
$oracleInstallerPath = "C:\OracleInstaller\setup.exe"  # Path to Oracle installer (update as per your environment)
$oracleBase = "C:\Oracle"
$oracleHome = "C:\Oracle\Product\19.0.0\Client_1"
$installType = "Custom"  # Options: "Administrator", "Runtime", "Custom"
$customComponents = @(
    "oracle.sqlplus:19.0.0.0.0",       # SQL*Plus
    "oracle.jdbc:19.0.0.0.0",          # JDBC/THIN Interfaces
    "oracle.ldap.client:19.0.0.0.0",   # Oracle Internet Directory Client
    "oracle.ntoledb:19.0.0.0.0",       # Oracle Provider for OLE DB
    "oracle.ntoledb.odp_net_2:19.0.0.0.0",  # Oracle Data Provider for .NET
    "oracle.aspnet2:19.0.0.0.0"        # Oracle Providers for ASP.NET
)  # Modify as needed for your custom components
$logLevel = "finest"  # Log level for troubleshooting (e.g., "info", "finest")

# Ensure Temp Directory Exists
$tempDir = Split-Path -Path $responseFilePath
if (-not (Test-Path -Path $tempDir)) {
    New-Item -ItemType Directory -Path $tempDir -Force
}

# Create Response File Content
$responseFileContent = @"
oracle.install.responseFileVersion=/oracle/install/rspfmt_clientinstall_response_schema_v19_0_0
oracle.install.client.installType=$installType
ORACLE_HOME=$oracleHome
ORACLE_BASE=$oracleBase
oracle.install.client.customComponents=$(if ($installType -eq "Custom") { $customComponents -join "," } else { "" })
oracle.install.IsBuiltinAccount=true
"@

# Save the Response File
$responseFileContent | Set-Content -Path $responseFilePath -Encoding UTF8
Write-Host "Response file created at $responseFilePath"

# Verify Oracle Installer Path
if (-not (Test-Path -Path $oracleInstallerPath)) {
    Write-Error "Oracle installer not found at $oracleInstallerPath. Please verify the path."
    exit 1
}

# Run Oracle Installer in Silent Mode
try {
    $arguments = @(
        "-silent",
        "-responseFile", "`"$responseFilePath`"",
        "-logLevel", $logLevel
    )
    Write-Host "Starting Oracle Client installation..."
    Start-Process -FilePath $oracleInstallerPath -ArgumentList $arguments -Wait -NoNewWindow
    Write-Host "Oracle Client installation completed successfully."
} catch {
    Write-Error "An error occurred during Oracle Client installation: $_"
}
