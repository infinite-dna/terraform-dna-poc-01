# Define Vault Name
$vaultName = "<vault-name>"

# Define the output file path
$secretsFilePath = "/tmp/secrets.json"

# Initialize or create the secrets file if it doesn't exist
if (Test-Path $secretsFilePath) {
    Remove-Item $secretsFilePath
}

# List all secrets from Key Vault
$secrets = az keyvault secret list --vault-name $vaultName --query "[].{name:name}" -o json | ConvertFrom-Json

# Loop through each secret and retrieve its value
foreach ($secret in $secrets) {
    $secretName = $secret.name

    # Retrieve the value of the current secret
    $secretValue = az keyvault secret show --vault-name $vaultName --name $secretName --query "value" -o tsv

    # Append the secret name and value to the output file
    "$secretName=$secretValue" | Out-File -Append -FilePath $secretsFilePath
}

Write-Host "Secrets have been successfully written to $secretsFilePath"
