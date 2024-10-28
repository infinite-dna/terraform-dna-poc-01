# Define the source and destination paths
$sourcePath = "C:\dna\temp\SQL.ini"
$destinationPath = "G:\Osi\bank\dll\SQL.ini"

# Copy the file
Copy-Item -Path $sourcePath -Destination $destinationPath -Force

# Confirm if the file has been copied
if (Test-Path -Path $destinationPath) {
    Write-Output "File copied successfully to $destinationPath"
} else {
    Write-Output "File copy failed."
}
