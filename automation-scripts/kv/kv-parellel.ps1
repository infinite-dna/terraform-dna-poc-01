# Define Vault Name
$vaultName = "<vault-name>"

# Define the output file path
$secretsFilePath = "/tmp/secrets.json"

# Initialize or create the secrets file if it exists
if (Test-Path $secretsFilePath) {
    Remove-Item $secretsFilePath
}

# List all secrets from Key Vault (fetch all names)
$secrets = az keyvault secret list --vault-name $vaultName --query "[].{name:name}" -o json | ConvertFrom-Json

# Create an array to store PowerShell job objects
$jobs = @()

# Loop through each secret and create a job to retrieve its value
foreach ($secret in $secrets) {
    $secretName = $secret.name

    # Start a PowerShell job to fetch the secret value asynchronously
    $jobs += Start-Job -ScriptBlock {
        param ($vaultName, $secretName, $secretsFilePath)

        # Fetch the secret value
        $secretValue = az keyvault secret show --vault-name $vaultName --name $secretName --query "value" -o tsv

        # Append the secret name and value to the output file
        "$secretName=$secretValue" | Out-File -Append -FilePath $secretsFilePath

    } -ArgumentList $vaultName, $secretName, $secretsFilePath
}

# Wait for all jobs to complete
Write-Host "Fetching secrets in parallel. Please wait..."
$jobs | Wait-Job

# Clean up completed jobs
$jobs | Receive-Job | Out-Null
$jobs | Remove-Job

Write-Host "Secrets have been successfully written to $secretsFilePath"
