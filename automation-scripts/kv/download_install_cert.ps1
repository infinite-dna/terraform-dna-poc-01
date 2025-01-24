param (
    [Parameter(Mandatory=$true)]
    [string]$SasUrl,  # The SAS URL of the certificate

    [Parameter(Mandatory=$true)]
    [string]$CertPassword  # The password for the PFX file
)

# Define the local path to store the downloaded certificate
$certPath = "$env:temp\certificate.pfx"

# Convert the password to a secure string
$securePassword = ConvertTo-SecureString -String $CertPassword -AsPlainText -Force

# Download the certificate
Invoke-WebRequest -Uri $SasUrl -OutFile $certPath

# Check if the certificate is already installed
$certThumbprint = Get-FileHash -Path $certPath -Algorithm SHA1 | Select-Object -ExpandProperty Hash

$existingCert = Get-ChildItem -Path Cert:\CurrentUser\My | Where-Object { $_.Thumbprint -eq $certThumbprint }

if (-not $existingCert) {
    Write-Host "Certificate is not installed. Installing now..."

    # Import the certificate to the Personal store
    Import-PfxCertificate -FilePath $certPath -CertStoreLocation Cert:\CurrentUser\My -Password $securePassword

    Write-Host "Certificate installed successfully."
} else {
    Write-Host "Certificate is already installed."
}

# Optionally, delete the downloaded certificate file after installation
Remove-Item -Path $certPath -Force
