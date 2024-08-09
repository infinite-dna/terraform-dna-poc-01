# Variables
$userName = "DOMAIN\Username"  # Replace with the domain and username you want to add
$policyName = "SeServiceLogonRight"
$seceditPath = "C:\Windows\Temp\secedit.inf"

# Debug: Starting the script
Write-Output "Starting script to add $userName to 'Log on as a service' policy."

# Export the current security policy to a temporary file
Write-Output "Exporting current security policy to $seceditPath..."
secedit.exe /export /cfg $seceditPath /areas USER_RIGHTS

# Check if the export was successful
if (Test-Path $seceditPath) {
    Write-Output "Policy export successful."
} else {
    Write-Error "Failed to export the policy. Exiting script."
    exit
}

# Read the policy file
Write-Output "Reading policy content..."
$policyContent = Get-Content $seceditPath

# Debug: Show current policy content
Write-Output "Current policy content:"
$policyContent | ForEach-Object { Write-Output $_ }

# Find and update the policy
$policyIndex = $policyContent.IndexOf("$policyName =")

if ($policyIndex -ge 0) {
    Write-Output "Found existing $policyName entry. Updating the entry..."
    $policyContent[$policyIndex] = $policyContent[$policyIndex] + ",$userName"
} else {
    Write-Output "No existing $policyName entry found. Adding a new entry..."
    $policyContent += "$policyName = $userName"
}

# Debug: Show updated policy content
Write-Output "Updated policy content:"
$policyContent | ForEach-Object { Write-Output $_ }

# Write the modified content back to the policy file
Write-Output "Writing updated policy back to $seceditPath..."
$policyContent | Set-Content $seceditPath

# Import the modified security policy
Write-Output "Importing the modified policy..."
secedit.exe /import /cfg $seceditPath /areas USER_RIGHTS

# Configure the system with the new policy
Write-Output "Configuring the system with the new policy..."
secedit.exe /configure /db secedit.sdb /cfg $seceditPath /areas USER_RIGHTS

# Check if the process was successful
if ($LASTEXITCODE -eq 0) {
    Write-Output "Successfully updated the 'Log on as a service' policy for $userName."
} else {
    Write-Error "Failed to update the policy. Please check the log for details."
}

# Clean up
Write-Output "Cleaning up temporary files..."
Remove-Item $seceditPath

Write-Output "Script completed."
