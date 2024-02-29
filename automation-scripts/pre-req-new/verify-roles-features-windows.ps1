# Define an array of feature names to check
$featuresToCheck = @(
    "Bitlocker",
    "EnhancedStorage",
    "File-Services",
    "FileAndStorage-Services",
    "MSMQ",
    "MSMQ-Server",
    "MSMQ-Services",
    "NET-Framework-45-ASPNET",
    "NET-Framework-45-CORE",
    "Powershell",
    "Powershell-ISE",
    "Powershell-V2",
    "RSAT",
    "RSAT-Feature-Tools",
    "RSAT-SNMP",
    "SNMP-Service",
    "Storage-Services",
    "System-DataArchiver",
    "WAS",
    "WAS-Config-APIs",
    "WAS-Process-Model",
    "Web-App-Dev",
    "Web-AppInit",
    "Web-ASP",
    "Web-ASP-Net",
    "Web-ASP-Net45",
    "Web-Basic-Auth",
    "Web-Common-Http",
    "Web-Default-Doc",
    "Web-Dir-Browsing",
    "Web-Filtering",
    "Web-Health",
    "Web-Http-Errors",
    "Web-http-logging",
    "web-isapi-ext",
    "web-isapi-Filter",
    "web-metabase",
    "web-mgmt-compat",
    "web-mgmt-console",
    "web-mgmt-tools",
    "web-net-ext",
    "web-net-ext45",
    "web-performance",
    "web-security",
    "Web-Stat-Compression",
    "web-static-content",
    "web-webserver",
    "windows-defender",
    "windows-identity-foundation",
    "wow64-Support",
    "XPS-Viewer",
    "NET-Framework-45-Features",
    "NET-WCF-HTTP-Activation45",
    "NET-WCF-MSMQ-Activation45",
    "NET-WCF-PIPE-Activation45",
    "NET-WCF-TCP-Activation45",
    "NET-WCF-TCP-PortSharing45"
)

# Check if each feature is installed
foreach ($feature in $featuresToCheck) {
    $installed = Get-WindowsFeature $feature | Where-Object {$_.Installed}
    if ($installed) {
        Write-Host "Feature '$feature' is installed."
    } else {
        Write-Host "Feature '$feature' is NOT installed."
    }
}
