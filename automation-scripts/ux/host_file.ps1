# Define function to update host file
function Update-HostsFile {
    param (
        [string]$CanonicalName,
        [string]$IPAddress
    )

    $hostsFile = "C:\Windows\System32\drivers\etc\hosts"
    $entry = "$IPAddress`t$CanonicalName"

    # Check if entry already exists, if not, add it
    if (Select-String -Path $hostsFile -Pattern $entry -Quiet) {
        Write-Host "Entry for $CanonicalName already exists in host file."
    } else {
        Add-Content -Path $hostsFile -Value $entry
        Write-Host "Entry for $CanonicalName added to host file."
    }
}

# Update host file with entries
Update-HostsFile -CanonicalName "localhost" -IPAddress "127.0.0.1"
Update-HostsFile -CanonicalName "azndnapocstorageaccount.file.core.windows.net" -IPAddress "10.155.189.151"
Update-HostsFile -CanonicalName "dnaappservers" -IPAddress "10.155.189.142"
Update-HostsFile -CanonicalName "dnaiuxservers" -IPAddress "127.0.0.1"
Update-HostsFile -CanonicalName "l7ld2dnanrc0001" -IPAddress "10.155.189.181"
Update-HostsFile -CanonicalName "l7ld2dnanrc0002" -IPAddress "10.155.189.180"
