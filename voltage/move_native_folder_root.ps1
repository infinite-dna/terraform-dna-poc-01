$RootFolder = "C:\YourRootFolder"  # Change this to your starting folder

# Get all subdirectories recursively and find setup.exe
$SetupFile = Get-ChildItem -Path $RootFolder -Filter "setup.exe" -Recurse -File | Select-Object -First 1

if ($SetupFile) {
    $SetupFolder = $SetupFile.DirectoryName  # Get the folder containing setup.exe
    
    if ($SetupFolder -ne $RootFolder) {
        # Get all files and folders from the setup directory
        $Items = Get-ChildItem -Path $SetupFolder -Force
        
        foreach ($Item in $Items) {
            $Destination = Join-Path -Path $RootFolder -ChildPath $Item.Name
            Move-Item -Path $Item.FullName -Destination $Destination -Force
        }
        
        Write-Output "Contents moved from $SetupFolder to $RootFolder"
    } else {
        Write-Output "setup.exe is already in the root folder. No need to move."
    }
} else {
    Write-Output "setup.exe not found in the folder structure."
}
