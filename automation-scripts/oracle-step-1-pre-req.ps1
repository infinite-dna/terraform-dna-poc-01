# Define the URL to download the zip file
$zipUrl = "https://download.fiservapps.com/ORACLE/ODAC/19c/ODAC193Xcopy_x64_OSI.zip"

# Define the path where the zip file will be saved
$zipFilePath = "$env:TEMP\ODAC193Xcopy_x64_OSI.zip"

# Define the path where the zip will be extracted
$extractedFolderPath = "$env:TEMP\ODAC193Xcopy_x64_OSI"

# Define the path for the Oracle x64 folder
$oracleFolderPath = "C:\oraclex64"

# Download the zip file
Invoke-WebRequest -Uri $zipUrl -OutFile $zipFilePath

# Extract the zip file to the temporary folder
Expand-Archive -Path $zipFilePath -DestinationPath $extractedFolderPath

# Change directory to the extracted folder
Set-Location -Path $extractedFolderPath

# Run install.bat to install ODAC
Start-Process -FilePath .\install.bat -ArgumentList "odp.net4 $oracleFolderPath odac4x64 true" -Wait

# Go to the Oracle x64 folder
Set-Location -Path $oracleFolderPath

# Run configure.bat to configure ODAC
Start-Process -FilePath .\configure.bat -ArgumentList "odp.net4 odac4x64 true true" -Wait

# Clean up temporary files
Remove-Item -Path $zipFilePath
Remove-Item -Path $extractedFolderPath -Recurse -Force
