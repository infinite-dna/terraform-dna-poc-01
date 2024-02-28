# Install Web Server (IIS) role with required features
Install-WindowsFeature -Name Web-Server -IncludeManagementTools  # Install the Web Server (IIS) role along with management tools
Install-WindowsFeature -Name Web-Basic-Auth  # Install Basic Authentication feature for IIS
Install-WindowsFeature -Name Web-App-Dev  # Install Application Development feature for IIS
Install-WindowsFeature -Name Web-Net-Ext47  # Install .NET Extensibility 4.7 feature for IIS
Install-WindowsFeature -Name Web-Asp-Net47  # Install ASP.NET 4.7 feature for IIS

# Install IIS Management Console
Install-WindowsFeature -Name RSAT-Web-Server  # Install Remote Server Administration Tools (RSAT) for managing the Web Server role
#use if the above does not work# Install IIS Management Console
#Install-WindowsFeature -Name Web-Mgmt-Console

# Install Application Server role with required features
###new lineInstall-WindowsFeature -Name NET-Framework-Features -IncludeAllSubFeatur
Install-WindowsFeature -Name Application-Server  # Install the Application Server role
Install-WindowsFeature -Name AS-NET-Framework-45-Core  # Install .NET Framework 4.7 feature for Application Server
Install-WindowsFeature -Name AS-HTTP-Activation  # Install HTTP Activation feature for Application Server
Install-WindowsFeature -Name AS-TCP-Activation  # Install TCP Activation feature for Application Server
Install-WindowsFeature -Name AS-WCF-Services45  # Install WCF Services 4.7 feature for Application Server

# Install .NET Core Framework
Invoke-WebRequest -Uri https://dot.net/v1/dotnet-install.ps1 -OutFile dotnet-install.ps1
.\dotnet-install.ps1 -Channel LTS -Version 3.1  # Change the version as needed

# Remove temporary files
Remove-Item -Path dotnet-install.ps1


### Install .NET Framework 4.x
Install-WindowsFeature -Name NET-Framework-Core

# Install HTTP Activation
Install-WindowsFeature -Name Web-Http-Activation

# Install TCP Activation
Install-WindowsFeature -Name WAS-Net-TCP-Activation45


Enable-WindowsOptionalFeature -Online -FeatureName WAS-Net-HTTP-Activation45

Enable-WindowsOptionalFeature -Online -FeatureName WAS-Net-TCP-Activation45

Enable-WindowsOptionalFeature -Online -FeatureName AS-WCF-Services45


#######
# Install HTTP Activation
Add-WindowsFeature NET-HTTP-Activation

# Install TCP Activation
# Install TCP Activation
Add-WindowsFeature -Name AS-Net-TCP-Activation


# Install WCF Services
Add-WindowsFeature AS-WCF-Services-45
