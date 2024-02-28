# Define the URL to download the zip file
$zipUrl = "https://download.fiservapps.com/ORACLE/ODAC/19c/instantclient-sqlplus-windows.x64-19.11.0.0.0dbru.zip"

# Define the path where the zip file will be saved
$zipFilePath = "$env:TEMP\instantclient-sqlplus-windows.x64-19.11.0.0.0dbru.zip"

# Define the path where the zip will be extracted
$extractedFolderPath = "$env:TEMP\instantclient-sqlplus-windows.x64-19.11.0.0.0dbru"

# Define the destination directory
$destinationDirectory = "C:\oraclex64"

# Download the zip file
Invoke-WebRequest -Uri $zipUrl -OutFile $zipFilePath

# Extract the zip file to the temporary folder
Expand-Archive -Path $zipFilePath -DestinationPath $extractedFolderPath

# Get the name of the subdirectory
$subdirectoryName = Get-ChildItem -Path $extractedFolderPath -Directory | Select-Object -First 1 -ExpandProperty Name

# Define the source directory
$sourceDirectory = Join-Path -Path $extractedFolderPath -ChildPath $subdirectoryName

# Move the contents of the subdirectory to the destination directory
Move-Item -Path "$sourceDirectory\*" -Destination $destinationDirectory -Force

# Update the PATH environment variable
$env:Path += ";${destinationDirectory}\bin"

# Output the updated PATH environment variable
$env:Path
