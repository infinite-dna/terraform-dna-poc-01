# Define the SAS URL of the certificate and the local path to store it
$sasUrl = "https://<your-sas-url-here>"
$certPath = "$env:temp\certificate.pfx"

# Define the password for the PFX file (if any)
$certPassword = ConvertTo-SecureString -String "<your-pfx-password>" -AsPlainText -Force

# Download the certificate
Invoke-WebRequest -Uri $sasUrl -OutFile $certPath

# Check if the certificate is already installed
$certThumbprint = Get-FileHash -Path $certPath -Algorithm SHA1 | Select-Object -ExpandProperty Hash

$existingCert = Get-ChildItem -Path Cert:\CurrentUser\My | Where-Object { $_.Thumbprint -eq $certThumbprint }

if (-not $existingCert) {
    Write-Host "Certificate is not installed. Installing now..."

    # Import the certificate to the Personal store
    Import-PfxCertificate -FilePath $certPath -CertStoreLocation Cert:\CurrentUser\My -Password $certPassword

    Write-Host "Certificate installed successfully."
} else {
    Write-Host "Certificate is already installed."
}

# Optionally, you can delete the downloaded certificate file after installation
Remove-Item -Path $certPath -Force
