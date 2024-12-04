# Variables
$SiteName = "Default Web Site"  # Replace with your site name if different
$Port = 443                     # HTTPS Port
$IPAddress = "*"                # Bind to all IPs
$MachineName = $env:COMPUTERNAME  # Automatically fetch the machine name
$CertStore = "Cert:\LocalMachine\My"  # Certificate store location

# Import IIS Administration Module
Import-Module WebAdministration

# Function to Get SSL Certificate Thumbprint by Name
function Get-CertificateThumbprint($CertName) {
    $Cert = Get-ChildItem $CertStore | Where-Object {
        $_.Subject -match "CN=$CertName" -and $_.NotAfter -gt (Get-Date)
    } | Select-Object -First 1

    if ($Cert) {
        return $Cert.Thumbprint
    } else {
        Write-Host "Certificate with name '$CertName' not found or expired." -ForegroundColor Red
        return $null
    }
}

# Check if the site exists
if (Get-ChildItem "IIS:\Sites\$SiteName" -ErrorAction SilentlyContinue) {
    Write-Host "Site '$SiteName' exists. Adding HTTPS binding..."

    # Get the certificate thumbprint
    $Thumbprint = Get-CertificateThumbprint $MachineName

    if ($Thumbprint) {
        # Check if the binding already exists
        $ExistingBinding = Get-WebBinding -Name $SiteName | Where-Object {
            $_.bindingInformation -like "*:$Port:$MachineName"
        }

        if ($null -eq $ExistingBinding) {
            # Add the HTTPS binding
            New-WebBinding -Name $SiteName -Protocol https -IPAddress $IPAddress -Port $Port -HostHeader $MachineName
            
            # Associate the SSL certificate with the binding
            Push-Location IIS:\SslBindings
            New-Item "0.0.0.0!$Port" -Thumbprint $Thumbprint -CertificateStoreName My
            Pop-Location
            
            Write-Host "HTTPS binding with SSL certificate added successfully for $MachineName:$Port"
        } else {
            Write-Host "HTTPS binding already exists for $MachineName:$Port"
        }
    }
} else {
    Write-Host "Site '$SiteName' does not exist. Please verify the site name." -ForegroundColor Red
}
