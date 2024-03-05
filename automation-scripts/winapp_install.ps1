 
# Define the URL of the WinAppDriver installer
$installerUrl = "https://github.com/microsoft/WinAppDriver/releases/download/v1.2/WindowsApplicationDriver.msi"

# Define the path where you want to save the installer
$installerPath = "C:\Temp\WinAppDriverInstaller.msi"

# Download the WinAppDriver installer
Invoke-WebRequest -Uri $installerUrl -OutFile $installerPath

# Install WinAppDriver
Start-Process -FilePath "msiexec.exe" -ArgumentList "/i $installerPath /quiet /norestart" -Wait

# Optionally, you can delete the installer file after installation
Remove-Item -Path $installerPath
