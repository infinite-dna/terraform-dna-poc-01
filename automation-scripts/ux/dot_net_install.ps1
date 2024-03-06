# Define function to check .NET Framework version
function Get-DotNetVersion {
    $dotNetPath = "HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full"
    $version = (Get-ItemProperty -Path $dotNetPath -Name Version).Version
    return $version
}

# Check current Microsoft .NET Framework version
$dotnet_version = Get-DotNetVersion

# Output current .NET Framework version
Write-Output "Current .NET Framework version: $dotnet_version"

# Download .NET Framework 4.8 if current version is less than 4.8.03761
if ([version]$dotnet_version -lt [version]"4.8.03761") {
    Invoke-WebRequest -Uri "https://artifactory.bank.onefiserv.net/artifactory/jenkins-support-tools/dotnet/framework/4.8/ndp48-x86-x64-allos-enu.exe" -OutFile "C:\Temp\ndp48-x86-x64-allos-enu.exe"

    # Install .NET Framework 4.8 if it has been downloaded
    if (Test-Path -Path "C:\Temp\ndp48-x86-x64-allos-enu.exe") {
        Start-Process -FilePath "C:\Temp\ndp48-x86-x64-allos-enu.exe" -ArgumentList "/quiet", "/install" -Wait
    }
}
