# Define the URL to download the installer
$installerUrl = "https://download.microsoft.com/download/1/2/8/128E2E22-C1B9-44A4-BE2A-5859ED1D4592/rewrite_amd64_en-US.msi"

# Define the path where the installer will be saved
$installerPath = "$env:TEMP\rewrite_amd64_en-US.msi"

# Download the installer
Invoke-WebRequest -Uri $installerUrl -OutFile $installerPath

# Install the installer
Start-Process -FilePath msiexec -ArgumentList "/i `"$installerPath`" /quiet /norestart" -Wait

# Remove the installer file
Remove-Item -Path $installerPath
