# Define variables
$ConfigFile = "C:\voltage\temp\runtimeconfig.ini"
$AppPoolName = "YourAppPoolName"  # Replace with actual app pool name
$VoltageFolder = "Voltage"
$CertPath = "C:\voltage\temp\certificate.pfx"

# Read config
$ConfigContent = Get-Content -Path $ConfigFile | ForEach-Object {
    $key, $value = $_ -split '=', 2
    @{ Key = $key.Trim(); Value = $value.Trim() }
} | Group-Object -AsHashTable -AsString

$CertURL = $ConfigContent["certURL"]
$CertPassword = $ConfigContent["certPassword"] | ConvertTo-SecureString -AsPlainText -Force

# Download certificate
Invoke-WebRequest -Uri $CertURL -OutFile $CertPath

# Import to LocalMachine\My
$Cert = Import-PfxCertificate -FilePath $CertPath -Password $CertPassword -CertStoreLocation "Cert:\LocalMachine\My"
$CertThumbprint = $Cert.Thumbprint -replace " ", ""

# Get App Pool SID
$AppPoolUser = "IIS AppPool\$AppPoolName"
$AppPoolSID = (New-Object System.Security.Principal.NTAccount($AppPoolUser)).Translate([System.Security.Principal.SecurityIdentifier])

# Get private key path
$KeyName = $Cert.PrivateKey.CspKeyContainerInfo.UniqueKeyContainerName
$KeyPath = "$env:ProgramData\Microsoft\Crypto\RSA\MachineKeys\$KeyName"

# Add permissions to key file
$acl = Get-Acl $KeyPath
$rule = New-Object System.Security.AccessControl.FileSystemAccessRule($AppPoolSID, "Read", "Allow")
$acl.AddAccessRule($rule)
Set-Acl -Path $KeyPath -AclObject $acl

# Create Voltage store if not exists
$store = New-Object System.Security.Cryptography.X509Certificates.X509Store($VoltageFolder, "LocalMachine")
$store.Open("ReadWrite")
$store.Add($Cert)
$store.Close()

# Remove from My store (optional, after verifying it's in Voltage)
$myStore = New-Object System.Security.Cryptography.X509Certificates.X509Store("My", "LocalMachine")
$myStore.Open("ReadWrite")
$myStore.Remove($Cert)
$myStore.Close()
