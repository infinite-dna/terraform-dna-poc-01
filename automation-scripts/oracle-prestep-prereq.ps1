# Define the URLs to download the installers
$installerUrls = @(
    "https://aka.ms/vs/17/release/vc_redist.x64.exe",
    "https://aka.ms/vs/17/release/vc_redist.x86.exe"
)

# Loop through each URL and download/install the redistributable
foreach ($url in $installerUrls) {
    # Define the path where the installer will be saved
    $installerPath = "$env:TEMP\" + ($url.Split('/')[-1])

    # Download the installer
    Invoke-WebRequest -Uri $url -OutFile $installerPath

    # Install the installer
    Start-Process -FilePath $installerPath -ArgumentList "/quiet /norestart" -Wait

    # Remove the installer file
    Remove-Item -Path $installerPath
}
