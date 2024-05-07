# Source path
$sourcePath = 'X:\'

# Destination path
$destinationPath = 'C:\temp'

# Copy the items from source to destination, including subfolders and their contents
Copy-Item -Path $sourcePath -Destination $destinationPath -Recurse -Force
 
