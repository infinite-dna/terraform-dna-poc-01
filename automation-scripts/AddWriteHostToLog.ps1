param (
    [string]$folderPath
)

# Check if the folder exists
if (-Not (Test-Path -Path $folderPath -PathType Container)) {
    Write-Host "The specified folder path does not exist."
    exit
}

# Recursively get all .ps1 files in the folder and subfolders
$ps1Files = Get-ChildItem -Path $folderPath -Recurse -Filter "*.ps1"

# Function to update the script
function Update-Script {
    param (
        [string]$filePath
    )

    # Read the content of the file
    $fileContent = Get-Content -Path $filePath

    # Find the Write-Log or logMessage function
    $updatedContent = $fileContent | ForEach-Object {
        if ($_ -match 'function (Write-Log|logMessage)') {
            # Add Write-Host $Message as the last line in the function
            $functionIndex = [array]::IndexOf($fileContent, $_)
            $functionLines = $fileContent[$functionIndex..($fileContent.Length - 1)]
            $lastLine = $functionLines[-1]
            
            if ($lastLine -notmatch 'Write-Host \$Message') {
                $updatedContent = $fileContent[0..($functionIndex + $functionLines.Length - 2)] + 'Write-Host $Message' + $fileContent[($functionIndex + $functionLines.Length - 1)..($fileContent.Length - 1)]
                $updatedContent
            } else {
                $fileContent
            }
        }
        else {
            $_
        }
    }

    # Write the updated content back to the file
    Set-Content -Path $filePath -Value $updatedContent
}

# Process each .ps1 file
foreach ($ps1File in $ps1Files) {
    Update-Script -filePath $ps1File.FullName
    Write-Host "Updated file: $($ps1File.FullName)"
}
