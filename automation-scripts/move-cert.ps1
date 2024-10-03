# Get the machine name
$machineName = $env:COMPUTERNAME

# Get the certificate from the Personal store based on the machine name
$personalCert = Get-ChildItem -Path Cert:\LocalMachine\My | Where-Object { $_.Subject -like "CN=$machineName*" }

if ($personalCert -ne $null) {
    # Export the certificate to a file
    $certFile = "C:\temp\cert.cer"
    $personalCert | Export-Certificate -FilePath $certFile -Type CERT

    # Check and remove any existing certificate in the Trusted Root Certification Authorities store
    $existingRootCert = Get-ChildItem -Path Cert:\LocalMachine\Root | Where-Object { $_.Subject -like "CN=$machineName*" }
    if ($existingRootCert) {
        Write-Output "Existing certificate found in Trusted Root Certification Authorities store. Removing it."
        $existingRootCert | Remove-Item
    }

    # Import the certificate into the Trusted Root Certification Authorities store
    Import-Certificate -FilePath $certFile -CertStoreLocation Cert:\LocalMachine\Root

    # Check and remove any existing certificate in the Trusted People store
    $existingTrustedPeopleCert = Get-ChildItem -Path Cert:\LocalMachine\TrustedPeople | Where-Object { $_.Subject -like "CN=$machineName*" }
    if ($existingTrustedPeopleCert) {
        Write-Output "Existing certificate found in Trusted People store. Removing it."
        $existingTrustedPeopleCert | Remove-Item
    }

    # Import the certificate into the Trusted People store
    Import-Certificate -FilePath $certFile -CertStoreLocation Cert:\LocalMachine\TrustedPeople

    # Cleanup the temporary certificate file
    Remove-Item -Path $certFile

    Write-Output "Certificate successfully moved to Trusted Root Certification Authorities and Trusted People stores."
} else {
    Write-Output "Certificate with name $machineName not found in Personal store."
}
