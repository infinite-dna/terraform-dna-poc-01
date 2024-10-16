param (
    [string]$iniFilePath = "C:\DNA\Temp\runtimeconfig.ini"
)

# Get the current machine name
$currentMachineName = $env:COMPUTERNAME

# Check if the INI file exists
if (Test-Path $iniFilePath) {
    # Read the contents of the INI file
    $iniContent = Get-Content $iniFilePath

    # Replace the vm-identifier with the current machine name
    $updatedContent = $iniContent -replace 'vm-identifier', $currentMachineName

    # Write the updated content back to the INI file
    Set-Content -Path $iniFilePath -Value $updatedContent

    # Output a message indicating the operation is complete
    Write-Host "The vm-identifier has been replaced with the current machine name: $currentMachineName"
} else {
    Write-Host "The specified INI file does not exist: $iniFilePath"
}
