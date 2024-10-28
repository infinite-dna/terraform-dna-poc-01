# Define the new path you want to add
$newPath = "G:\osi\bank\dll"

# Retrieve the current PATH from the system environment variables
$currentPath = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::Machine)

# Check if the new path is already in the PATH
if ($currentPath -notlike "*$newPath*") {
    # Append the new path to the existing PATH
    $updatedPath = "$currentPath;$newPath"

    # Set the new PATH to the system environment variables
    [System.Environment]::SetEnvironmentVariable("Path", $updatedPath, [System.EnvironmentVariableTarget]::Machine)
    
    Write-Output "Path '$newPath' added to the system PATH."
} else {
    Write-Output "Path '$newPath' is already in the system PATH."
}
