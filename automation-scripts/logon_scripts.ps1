# Define the username
$username = "windowsadmin"

# Convert username to SID
$userSID = (New-Object System.Security.Principal.NTAccount($username)).Translate([System.Security.Principal.SecurityIdentifier]).Value

# Add the user SID to the list of accounts with "Logon as a service" rights using secedit.exe
secedit.exe /areas USER_RIGHTS /cfg "$env:temp\temp.inf"
Add-Content "$env:temp\temp.inf" "`r`n[Privilege Rights]"
Add-Content "$env:temp\temp.inf" "SeServiceLogonRight = *$userSID"
secedit.exe /configure /db "$env:windir\security\local.sdb" /cfg "$env:temp\temp.inf" /areas USER_RIGHTS /overwrite /quiet

Write-Host "User $username has been granted 'Logon as a service' rights."
