# Define the path to the folder you want to grant access to
$folderPath = "C:\path\to\your\folder"

# Get the IIS user group name
$iisUserGroupName = "IIS_IUSRS"

# Get the security object for the folder
$acl = Get-Acl -Path $folderPath

# Get the machine name
$machineName = $env:COMPUTERNAME

# Get the SID for the IIS user group
$iisUserGroupSID = Get-LocalGroup $iisUserGroupName | Select-Object -ExpandProperty SID

# Check if the IIS user group SID is obtained successfully
if ($iisUserGroupSID -eq $null) {
    Write-Host "Error: Unable to retrieve the SID for the $iisUserGroupName group."
    exit 1
}

# Create a new access rule for the IIS user group with full control
$accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule($iisUserGroupSID,"FullControl","Allow")

# Add the access rule to the ACL
$acl.AddAccessRule($accessRule)

# Set the modified ACL back to the folder
Set-Acl -Path $folderPath -AclObject $acl
