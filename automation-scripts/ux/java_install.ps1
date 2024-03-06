# Define function to copy file
function Copy-File {
    param (
        [string]$Source,
        [string]$Destination
    )

    # Check if destination folder exists, if not, create it
    if (!(Test-Path -Path $Destination)) {
        New-Item -ItemType Directory -Path $Destination -Force
    }

    # Copy file
    Copy-Item -Path $Source -Destination $Destination -Force
}

# Copy Java installer to temp folder
Copy-File -Source "\\azndnapocstorageaccount.file.core.windows.net\dnaprereqsShare\jre-8u371-windows-x64.exe" -Destination "C:\Temp\"

# Install Java
Start-Process -FilePath "C:\Temp\jre-8u371-windows-x64.exe" -ArgumentList "/s" -Wait

# Set JAVA_HOME environment variable
[Environment]::SetEnvironmentVariable("JAVA_HOME", "C:\Program Files\Java\jdk1.8.0", [System.EnvironmentVariableTarget]::Machine)

# Append Java bin directory to PATH
$oldPath = [Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::Machine)
$newPath = $oldPath + ";C:\Program Files\Java\jdk1.8.0\bin"
[Environment]::SetEnvironmentVariable("Path", $newPath, [System.EnvironmentVariableTarget]::Machine)

# Verify Java installation
$javaVersionOutput = & "java.exe" -version 2>&1

# Display Java version
Write-Output "Java version: $javaVersionOutput"
