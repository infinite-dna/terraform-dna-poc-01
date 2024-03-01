# Specify the directory you want to add to the PATH
$newPath = "C:\New\Directory"

# Get the current value of the PATH environment variable
$currentPath = [Environment]::GetEnvironmentVariable("PATH", "Machine")

# Check if the directory is already in the PATH
if ($currentPath -notlike "*$newPath*") {
    # Append the new directory to the PATH, separating with a semicolon
    $newPathToAdd = $currentPath + ";" + $newPath
    
    # Set the updated PATH environment variable for the machine
    [Environment]::SetEnvironmentVariable("PATH", $newPathToAdd, "Machine")

    Write-Host "Directory added to PATH."
} else {
    Write-Host "Directory is already in PATH."
}
