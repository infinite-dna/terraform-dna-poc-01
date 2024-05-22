# Define the registry paths
$policiesPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell"
$executionPolicyKey = "ExecutionPolicy"
$executionPolicyValue = "RemoteSigned"

# Create the registry key if it does not exist
if (-not (Test-Path $policiesPath)) {
    New-Item -Path $policiesPath -Force | Out-Null
}

# Set the execution policy for the local machine
Set-ItemProperty -Path $policiesPath -Name $executionPolicyKey -Value $executionPolicyValue -Force

# Set the execution policy for the current user
$policiesPathUser = "HKCU:\SOFTWARE\Policies\Microsoft\Windows\PowerShell"
if (-not (Test-Path $policiesPathUser)) {
    New-Item -Path $policiesPathUser -Force | Out-Null
}
Set-ItemProperty -Path $policiesPathUser -Name $executionPolicyKey -Value $executionPolicyValue -Force

# Confirm the execution policies have been set
"Execution policy for Local Machine set to: $(Get-ItemProperty -Path $policiesPath).$executionPolicyKey"
"Execution policy for Current User set to: $(Get-ItemProperty -Path $policiesPathUser).$executionPolicyKey"
