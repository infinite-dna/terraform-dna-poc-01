# Define variables
$ConfigFile = "C:\voltage\temp\runtimeconfig.ini"
$AppPoolName = "YourAppPoolName"  # Replace with the actual app pool name
$VoltageFolder = "Voltage"

# Read the configuration file
$ConfigContent = Get-Content -Path $ConfigFile | ForEach-Object {
    $key, $value = $_ -split '=', 2
    @{ Key = $key.Trim(); Value = $value.Trim() }
} | Group-Object -AsHashTable -AsString

$CertURL = $ConfigContent["certURL"]
$CertPassword = $ConfigContent["certPassword"] | ConvertTo-SecureString -AsPlainText -Force
$CertPath = "C:\voltage\temp\certificate.pfx"

# Download the certificate
Invoke-WebRequest -Uri $CertURL -OutFile $CertPath

# Import the certificate
$Cert = Import-PfxCertificate -FilePath $CertPath -Password $CertPassword -CertStoreLocation "Cert:\LocalMachine\My"

# Create Voltage folder in Cert:
$store = New-Object System.Security.Cryptography.X509Certificates.X509Store($VoltageFolder, "LocalMachine")
$store.Open("ReadWrite")
$store.Close()

# Assign permissions to IIS_IUSRS and the logged-in user
$LoggedInUser = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
$Acl = Get-Acl "Cert:\LocalMachine\My\$($Cert.Thumbprint)"

$Permissions = @(
    New-Object System.Security.AccessControl.FileSystemAccessRule("IIS_IUSRS", "Read", "Allow"),
    New-Object System.Security.AccessControl.FileSystemAccessRule($LoggedInUser, "Read", "Allow")
)

Foreach ($Permission in $Permissions) {
    $Acl.AddAccessRule($Permission)
}

Set-Acl -Path "Cert:\LocalMachine\My\$($Cert.Thumbprint)" -AclObject $Acl

# Assign permissions to App Pool
$AppPoolIdentity = "IIS AppPool\$AppPoolName"
$AppPoolPermission = New-Object System.Security.AccessControl.FileSystemAccessRule($AppPoolIdentity, "Read", "Allow")
$Acl.AddAccessRule($AppPoolPermission)
Set-Acl -Path "Cert:\LocalMachine\My\$($Cert.Thumbprint)" -AclObject $Acl

# Move certificate to Voltage folder
Move-Item -Path "Cert:\LocalMachine\My\$($Cert.Thumbprint)" -Destination "Cert:\LocalMachine\$VoltageFolder" -Force
