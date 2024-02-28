# Define the URL to download Web Deploy 3.6
$webDeployUrl = "https://download.microsoft.com/download/9/1/5/9159A76A-07A6-4E95-B9B2-A17715A09BB8/WebDeploy_amd64_en-US.msi"

# Define the path where the installer will be saved
$installerPath = "$env:TEMP\WebDeploy.msi"

# Download the Web Deploy installer
Invoke-WebRequest -Uri $webDeployUrl -OutFile $installerPath

# Install Web Deploy
Start-Process -FilePath msiexec -ArgumentList "/i `"$installerPath`" /quiet /norestart" -Wait

# Remove the installer file
Remove-Item -Path $installerPath
