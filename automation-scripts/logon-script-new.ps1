# Variables
$userName = "DOMAIN\cmcuser"  # Replace with the domain and username you want to add
$policyName = "SeInteractiveLogonRight"

# Get current policy
$currentUsers = (secedit.exe /export /cfg C:\Windows\Temp\secedit.inf /areas USER_RIGHTS | Out-String) -split "(\r?\n)+" | Select-String $policyName

# Add user to the policy
if ($currentUsers) {
    $updatedUsers = $currentUsers -replace ("$policyName =.*"), ("$policyName = " + ($currentUsers -replace ".*= " + $userName + ",")) 
} else {
    $updatedUsers = $policyName + " = " + $userName
}

# Update the security policy
secedit.exe /import /cfg C:\Windows\Temp\secedit.inf /areas USER_RIGHTS
secedit.exe /configure /db secedit.sdb /cfg C:\Windows\Temp\secedit.inf /areas USER_RIGHTS

# Clean up
Remove-Item C:\Windows\Temp\secedit.inf
