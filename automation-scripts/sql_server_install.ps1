# Define variables
$setupMediaPath = "C:\Path\To\SQL\Setup\Media\SQLServerSetup.exe"
$instanceName = "YourInstanceName"
$adminLogin = "YourAdminLogin"
$adminPassword = "YourAdminPassword"

# Run SQL Server setup silently
Start-Process -FilePath $setupMediaPath -ArgumentList "/Q", "/IACCEPTSQLSERVERLICENSETERMS", "/ACTION=Install", "/INSTANCENAME=$instanceName", "/SECURITYMODE=SQL", "/SAPWD=$adminPassword" -Wait

# Start SQL Server service
Start-Service -Name "MSSQL`$$instanceName"

# Enable SQL Server Browser service
Set-Service -Name "SQLBrowser" -StartupType Automatic
Start-Service -Name "SQLBrowser"
