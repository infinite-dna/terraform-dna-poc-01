# Check if SvcTraceViewer exists
$svcTraceViewerPath = "C:\Temp\SvcTraceViewer.exe"
$svcTraceViewerExists = Test-Path $svcTraceViewerPath

if (-not $svcTraceViewerExists) {
    # Download SvcTraceViewer.exe
    $svcTraceViewerUrl = "https://test-app/artifactory/jenkins-support-tools/dna/pre-requisite-software/SvcTraceViewer.exe"
    Invoke-WebRequest -Uri $svcTraceViewerUrl -OutFile $svcTraceViewerPath
}

# Install .NET Framework 3.5
Add-WindowsFeature -Name NET-Framework-Core

# Check current Microsoft .NET Framework version
$dotnetVersion = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full").Version

# Download Microsoft .NET Framework 4.8 if version is less than 4.8.03761
if ([version]$dotnetVersion -lt [version]"4.8.03761") {
    $dotnetInstallerUrl = "https://test-app/artifactory/jenkins-support-tools/dotnet/framework/4.8/ndp48-x86-x64-allos-enu.exe"
    $dotnetInstallerPath = "C:\Temp\ndp48-x86-x64-allos-enu.exe"
    Invoke-WebRequest -Uri $dotnetInstallerUrl -OutFile $dotnetInstallerPath
    # Install Microsoft .NET 4.8
    Start-Process -FilePath $dotnetInstallerPath -ArgumentList "/quiet", "/install" -Wait
}

# Download 7-Zip
$zipUrl = "https://artifactory.bank.onefiserv.net/artifactory/jenkins-support-tools/dna/pre-requisite-software/7z2201-x64.exe"
$zipPath = "C:\Temp\7z2201-x64.exe"
Invoke-WebRequest -Uri $zipUrl -OutFile $zipPath

# Install 7-Zip
Start-Process -FilePath $zipPath -ArgumentList "/S" -Wait

# Download Notepad++
$notepadUrl = "\\azndnapocstorageaccount.file.core.windows.net\dnaprereqsShare\npp.7.9.5.Installer.exe"
$notepadPath = "C:\Temp\npp.7.9.5.Installer.exe"
Invoke-WebRequest -Uri $notepadUrl -OutFile $notepadPath

# Install Notepad++
Start-Process -FilePath $notepadPath -ArgumentList "/S" -Wait
 
