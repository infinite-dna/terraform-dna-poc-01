Get-Module -Name PowerShellGet -ListAvailable

Import-Module PowerShellGet -Force


Get-PackageProvider -Name NuGet -Force -ListAvailable
Install-PackageProvider -Name NuGet -Force -Scope CurrentUser
Import-PackageProvider -Name NuGet

Install-Module -Name PowerShellGet -Force -Scope CurrentUser

Get-ExecutionPolicy
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned

Import-Module -Name UIAutomation -Force

Get-Module -Name UIAutomation -ListAvailable
