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

# Authenticate using the Service Principal
$SecureClientSecret = ConvertTo-SecureString -String $ClientSecret -AsPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential($ClientId, $SecureClientSecret)

Connect-AzAccount -ServicePrincipal -TenantId $TenantId -Credential $Credential

# Extract Key Vault name from Key Vault URI
$KeyVaultName = ($KeyVaultUri -replace "https://", "") -split "\.vault.azure.net" | Select-Object -First 1

# Fetch the certificate as a secret from Azure Key Vault
$secret = Get-AzKeyVaultSecret -VaultName $KeyVaultName -Name $CertName

# The secret value contains the Base64-encoded PFX certificate
$base64Cert = $secret.SecretValueText

# Define the local path to store the downloaded certificate
$certPath = "$env:temp\$CertName.pfx"

# Decode the Base64 string and write the certificate to a .pfx file
[System.IO.File]::WriteAllBytes($certPath, [Convert]::FromBase64String($base64Cert))

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
