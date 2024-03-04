# Specify the download URL for SSMS
$downloadUrl = "https://aka.ms/ssmsfullsetup"

# Specify the path where you want to save the installer
$installerPath = "C:\Temp\SSMS-Setup-ENU (1).exe"

# Download the SSMS installer
Invoke-WebRequest -Uri $downloadUrl -OutFile $installerPath

# Install SSMS silently
Start-Process -FilePath $installerPath -ArgumentList "/install /quiet /norestart" -Wait
 
