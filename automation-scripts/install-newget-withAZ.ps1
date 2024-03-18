# Check if NuGet is installed, if not, install it
if (-not (Get-Command nuget -ErrorAction SilentlyContinue)) {
    Write-Output "NuGet is not installed. Installing NuGet..."
    Invoke-WebRequest -Uri https://dist.nuget.org/win-x86-commandline/latest/nuget.exe -OutFile nuget.exe
    # Optionally, you can move nuget.exe to a directory in your PATH environment variable
    # Move-Item -Path .\nuget.exe -Destination $env:USERPROFILE\bin -Force
}

# Install or update the Azure PowerShell module
Write-Output "Installing or updating the Azure PowerShell module..."
Install-Module -Name Az -Force
