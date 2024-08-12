function Add-RightToUser([string] $Username, $Right) {
    $tmp = New-TemporaryFile

    $TempConfigFile = "$tmp.inf"
    $TempDbFile = "$tmp.sdb"

    Write-Host "Getting current policy"
    secedit /export /cfg $TempConfigFile

    $sid = ((New-Object System.Security.Principal.NTAccount($Username)).Translate([System.Security.Principal.SecurityIdentifier])).Value

    $currentConfig = Get-Content -Encoding ascii $TempConfigFile

    $newConfig = $null

    if ($currentConfig | Select-String -Pattern "^$Right = ") {
        if ($currentConfig | Select-String -Pattern "^$Right .*$sid.*$") {
            Write-Host "Already has right"
        }
        else {
            Write-Host "Adding $Right to $Username"

            $newConfig = $currentConfig -replace "^$Right .+", "`$0,*$sid"
        }
    }
    else {
        Write-Host "Right $Right did not exist in config. Adding $Right to $Username."

        $newConfig = $currentConfig -replace "^\[Privilege Rights\]$", "`$0`n$Right = *$sid"
    }

    if ($newConfig) {
        Set-Content -Path $TempConfigFile -Encoding ascii -Value $newConfig

        Write-Host "Validating configuration"
        $validationResult = secedit /validate $TempConfigFile

        if ($validationResult | Select-String '.*invalid.*') {
            throw $validationResult;
        }
        else {
            Write-Host "Validation Succeeded"
        }

        Write-Host "Importing new policy on temp database"
        secedit /import /cfg $TempConfigFile /db $TempDbFile

        Write-Host "Applying new policy to machine"
        secedit /configure /db $TempDbFile /cfg $TempConfigFile

        Write-Host "Updating policy"
        gpupdate /force

        Remove-Item $tmp* -ea 0
    }
}

# Step 1: Check if user exists
$username = "cmcuser"
$userExists = Get-LocalUser -Name $username -ErrorAction SilentlyContinue

if (-not $userExists) {
    # Disable password complexity
    $passwordPolicyFile = "$env:TEMP\passwordpolicy.inf"
    secedit /export /cfg $passwordPolicyFile
    (Get-Content $passwordPolicyFile).replace("PasswordComplexity = 1", "PasswordComplexity = 0") | Set-Content $passwordPolicyFile
    secedit /configure /db $env:TEMP\secedit.sdb /cfg $passwordPolicyFile /areas SECURITYPOLICY

    # Define the password
    $password = ConvertTo-SecureString "cmc" -AsPlainText -Force

    # Create the user
    New-LocalUser -Name $username -Password $password -FullName "CMC User" -Description "Admin user for CMC services"

    # Add the user to the "Administrators" group
    Add-LocalGroupMember -Group "Administrators" -Member $username

    # Clean up the temporary files
    Remove-Item $passwordPolicyFile
}

# Use the current machine name
$currentMachineName = $env:COMPUTERNAME
$domainUser = "$currentMachineName\$username"

# Assign "Log on as a service" rights
Add-RightToUser -Username $domainUser -Right 'SeServiceLogonRight'
