# Install Web Server (IIS) role with required features
Install-WindowsFeature -Name Web-Server -IncludeManagementTools
Install-WindowsFeature -Name Web-Basic-Auth
Install-WindowsFeature -Name Web-App-Dev
Install-WindowsFeature -Name Web-Net-Ext47
Install-WindowsFeature -Name Web-Asp-Net47

# Install IIS Management Console
Install-WindowsFeature -Name RSAT-Web-Server

# Install Application Server role with required features
Install-WindowsFeature -Name Application-Server
Install-WindowsFeature -Name AS-NET-Framework-45-Core
Install-WindowsFeature -Name AS-HTTP-Activation
Install-WindowsFeature -Name AS-TCP-Activation
Install-WindowsFeature -Name AS-WCF-Services45

# Install .NET Core Framework
Invoke-WebRequest -Uri https://dot.net/v1/dotnet-install.ps1 -OutFile dotnet-install.ps1
.\dotnet-install.ps1 -Channel LTS -Version 3.1

# Remove temporary files
Remove-Item -Path dotnet-install.ps1

# Enable HTTP Activation
Enable-WindowsOptionalFeature -Online -FeatureName WAS-Net-HTTP-Activation45

# Enable TCP Activation
Enable-WindowsOptionalFeature -Online -FeatureName WAS-Net-TCP-Activation45

# Enable WCF Services
Enable-WindowsOptionalFeature -Online -FeatureName AS-WCF-Services45
 
