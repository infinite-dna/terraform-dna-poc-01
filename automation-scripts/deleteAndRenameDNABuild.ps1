param (
    [string]$filePath = "C:\DNA\Temp",
    [int]$sequenceNumber = 1
)

# Define the full path for DNA.zip and DNA folder
$dnaZipPath = Join-Path -Path $filePath -ChildPath "DNA.zip"
$dnaFolderPath = Join-Path -Path $filePath -ChildPath "DNA"
$newFolderName = "DNA-$sequenceNumber"
$newFolderPath = Join-Path -Path $filePath -ChildPath $newFolderName

# Check and delete the DNA.zip file if it exists
if (Test-Path -Path $dnaZipPath) {
    Write-Output "Deleting file: $dnaZipPath"
    Remove-Item -Path $dnaZipPath -Force
} else {
    Write-Output "File not found: $dnaZipPath"
}

# Check and rename the DNA folder if it exists
if (Test-Path -Path $dnaFolderPath) {
    Write-Output "Renaming folder: $dnaFolderPath to $newFolderPath"
    Rename-Item -Path $dnaFolderPath -NewName $newFolderName
} else {
    Write-Output "Folder not found: $dnaFolderPath"
}
