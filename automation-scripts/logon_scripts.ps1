# Define the username
$username = "windowsadmin"

# Get the SID of the user
$userSID = (Get-WmiObject Win32_UserAccount | Where-Object { $_.Name -eq $username }).SID

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
 
