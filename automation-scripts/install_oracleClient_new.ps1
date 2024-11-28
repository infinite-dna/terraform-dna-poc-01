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
    "-silent",                                 # Run installer in silent mode
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

# Start Installation Process and suppress the "Press Enter to Exit" prompt
try {
    Write-Host "Starting Oracle Client installation in silent mode..."
    
    # Start the Oracle Installer and redirect standard input to null to suppress "Press Enter" prompt
    $process = Start-Process -FilePath $oracleInstallerPath -ArgumentList $arguments -Wait -NoNewWindow -PassThru
    
    # Wait for the process to finish and then automatically close it
    $process.WaitForExit()
    
    # After installation completes, ensure it exits without asking to "Press Enter"
    if ($process.HasExited) {
        Write-Host "Oracle Client installation completed successfully."
    } else {
        Write-Host "Oracle installation process didn't finish as expected."
    }

} catch {
    Write-Error "An error occurred during Oracle Client installation: $_"
}
