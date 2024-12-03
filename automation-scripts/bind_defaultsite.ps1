# Variables
$SiteName = "Default Web Site"  # Replace with your site name if different
$Port = 80                      # HTTP Port
$IPAddress = "*"                # Bind to all IPs, or specify an IP
$MachineName = $env:COMPUTERNAME  # Automatically fetch the machine name

# Import IIS Administration Module
Import-Module WebAdministration

# Check if the site exists
if (Get-ChildItem "IIS:\Sites\$SiteName" -ErrorAction SilentlyContinue) {
    Write-Host "Site '$SiteName' exists. Adding binding..."
    
    # Check if the binding already exists
    $ExistingBinding = Get-WebBinding -Name $SiteName | Where-Object {
        $_.bindingInformation -like "*:$Port:$MachineName"
    }

    if ($null -eq $ExistingBinding) {
        # Add the binding
        New-WebBinding -Name $SiteName -Protocol http -IPAddress $IPAddress -Port $Port -HostHeader $MachineName
        Write-Host "Binding added successfully: $MachineName:$Port"
    } else {
        Write-Host "Binding already exists for $MachineName:$Port"
    }
} else {
    Write-Host "Site '$SiteName' does not exist. Please verify the site name." -ForegroundColor Red
}
