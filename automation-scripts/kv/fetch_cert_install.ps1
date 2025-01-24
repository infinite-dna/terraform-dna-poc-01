param (
    [Parameter(Mandatory=$true)]
    [string]$TenantId,  # Azure Tenant ID

    [Parameter(Mandatory=$true)]
    [string]$ClientId,  # Azure Service Principal Client ID

    [Parameter(Mandatory=$true)]
    [string]$ClientSecret,  # Azure Service Principal Client Secret

    [Parameter(Mandatory=$true)]
    [string]$KeyVaultUri,  # The URI of the Azure Key Vault

    [Parameter(Mandatory=$true)]
    [string]$CertName,  # The name of the certificate in Key Vault

    [Parameter(Mandatory=$true)]
    [string]$CertPassword  # The password for the PFX file (if needed)
)
Install-Module -Name Az -AllowClobber -Force -SkipPublisherCheck

# Authenticate using the Service Principal
$SecureClientSecret = ConvertTo-SecureString -String $ClientSecret -AsPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential($ClientId, $SecureClientSecret)

Connect-AzAccount -ServicePrincipal -TenantId $TenantId -Credential $Credential

# Fetch the certificate from Azure Key Vault
$cert = Get-AzKeyVaultCertificate -VaultUri $KeyVaultUri -Name $CertName

# Define the local path to store the downloaded certificate
$certPath = "$env:temp\$CertName.pfx"

# Export the certificate as a PFX file (use the password if required)
$certExport = Export-AzKeyVaultCertificate -VaultUri $KeyVaultUri -Name $CertName -FilePath $certPath -Password (ConvertTo-SecureString -String $CertPassword -AsPlainText -Force)

# Check if the certificate is already installed
$certThumbprint = Get-FileHash -Path $certPath -Algorithm SHA1 | Select-Object -ExpandProperty Hash

$existingCert = Get-ChildItem -Path Cert:\CurrentUser\My | Where-Object { $_.Thumbprint -eq $certThumbprint }

if (-not $existingCert) {
    Write-Host "Certificate is not installed. Installing now..."

    # Import the certificate to the Personal store
    Import-PfxCertificate -FilePath $certPath -CertStoreLocation Cert:\CurrentUser\My -Password (ConvertTo-SecureString -String $CertPassword -AsPlainText -Force)

    Write-Host "Certificate installed successfully."
} else {
    Write-Host "Certificate is already installed."
}

# Optionally, delete the downloaded certificate file after installation
Remove-Item -Path $certPath -Force
