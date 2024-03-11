# Define the path to the folder you want to grant access to
$folderPath = "C:\path\to\your\folder"

# Get the IIS user group name
$iisUserGroupName = "IIS_IUSRS"

# Get the security object for the folder
$acl = Get-Acl -Path $folderPath

# Get the machine name
$machineName = $env:COMPUTERNAME

# Create a permission object for the IIS user group to have full control
$permission = "$machineName\$iisUserGroupName","FullControl","Allow"
$accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule($permission)

# Add the access rule to the ACL
$acl.AddAccessRule($accessRule)

# Set the modified ACL back to the folder
Set-Acl -Path $folderPath -AclObject $acl
