# Check if the script is running as administrator
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    # Restart the script as administrator
    Start-Process powershell.exe -ArgumentList "-File `"$PSCommandPath`"" -Verb RunAs
    exit
}

# Set execution policy to RemoteSigned or Unrestricted
Set-ExecutionPolicy -Scope Process -ExecutionPolicy RemoteSigned -Force

# Define the paths to the script files
$scriptDir = $PSScriptRoot
$scripts = @(
    "Server-Install-PreReq.ps1",
    "web-deploy-preReq.ps1",
    "url-rewrite-pre-req.ps1",
    "oracle-prestep-prereq.ps1",
    "oracle-step-1-pre-req.ps1",
    "oracle-step2-preReq.ps1"
)

# Run each script one by one
foreach ($script in $scripts) {
    $scriptPath = Join-Path -Path $scriptDir -ChildPath $script
    Start-Process powershell.exe -ArgumentList "-ExecutionPolicy Bypass -File `"$scriptPath`"" -Wait
}
