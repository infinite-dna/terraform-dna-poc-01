# Define the username
$username = "windowsadmin"

# Convert username to SID
$userSID = (New-Object System.Security.Principal.NTAccount($username)).Translate([System.Security.Principal.SecurityIdentifier]).Value

# Get the local security policy
$secedit = New-Object -ComObject "Microsoft.GroupPolicy.Gpmc"

# Get the security settings for the "Logon as a service" policy
$settings = $secedit.GetSecuritySettings("Machine", "Account")

# Add the user SID to the list of accounts with "Logon as a service" rights
$settings.AddAccountRight($userSID, "SeServiceLogonRight")

# Apply the modified security settings
$secedit.SetSecuritySettings("Machine", "Account", $settings)

# Dispose of the COM object
$secedit.Dispose()

Write-Host "User $username has been granted 'Logon as a service' rights."
