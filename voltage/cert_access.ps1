# Variables
$thumbprint = "<your-certificate-thumbprint>" -replace ' ', ''  # Remove spaces
$appPoolName = "YourAppPoolName"
$additionalGroups = @("IIS_IUSRS")  # Add more groups if needed

# Find the certificate
$cert = Get-ChildItem -Path Cert:\LocalMachine\My | Where-Object { $_.Thumbprint -eq $thumbprint }
if (-not $cert) {
    Write-Error "Certificate with thumbprint $thumbprint not found."
    exit 1
}

# Locate the private key file
$keyName = $cert.PrivateKey.CspKeyContainerInfo.UniqueKeyContainerName
$keyPath = "$env:ProgramData\Microsoft\Crypto\RSA\MachineKeys\$keyName"

# Prepare list of identities
$currentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
$usersToGrant = @(
    "IIS AppPool\$appPoolName",
    $currentUser
) + $additionalGroups

# Update ACL
$acl = Get-Acl $keyPath

foreach ($user in $usersToGrant) {
    try {
        $sid = (New-Object System.Security.Principal.NTAccount($user)).Translate([System.Security.Principal.SecurityIdentifier])
        $rule = New-Object System.Security.AccessControl.FileSystemAccessRule($sid, "FullControl", "Allow")
        $acl.AddAccessRule($rule)
        Write-Host "Granted FullControl to: $user"
    } catch {
        Write-Warning "Could not find or add access for $user. Error: $_"
    }
}

# Apply the updated ACL
Set-Acl -Path $keyPath -AclObject $acl
Write-Host "Access rules successfully updated on the private key file."
