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

# Grant permissions using certutil
$CertThumbprint = $Cert.Thumbprint

# Convert AppPoolName to SID
$AppPoolSID = (New-Object System.Security.Principal.NTAccount("IIS AppPool\$AppPoolName")).Translate([System.Security.Principal.SecurityIdentifier]).Value

# Use certutil to modify permissions
$Permissions = @("IIS_IUSRS", [System.Security.Principal.WindowsIdentity]::GetCurrent().Name, $AppPoolSID)
foreach ($User in $Permissions) {
    Start-Process -FilePath "certutil.exe" -ArgumentList "-repairstore My $CertThumbprint", "-user $User" -NoNewWindow -Wait
}

# Move certificate to Voltage folder
Move-Item -Path "Cert:\LocalMachine\My\$CertThumbprint" -Destination "Cert:\LocalMachine\$VoltageFolder" -Force
