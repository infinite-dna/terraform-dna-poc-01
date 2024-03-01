# Create folder structure
$foldersToCreate = @(
    "C:\DNA\Temp",
    "C:\DNA\Logs"
)

foreach ($folder in $foldersToCreate) {
    if (-not (Test-Path -Path $folder -PathType Container)) {
        New-Item -Path $folder -ItemType Directory -Force
    }
}

# Download files from shared location
$sourcePath = "\\10.0.0.1\files"
$destinationPath = "C:\DNA\Temp"

$filesToDownload = Get-ChildItem -Path $sourcePath

foreach ($file in $filesToDownload) {
    $destinationFile = Join-Path -Path $destinationPath -ChildPath $file.Name
    Copy-Item -Path $file.FullName -Destination $destinationFile -Force
}

# Set current location to C:\DNA
Set-Location -Path "C:\DNA"
