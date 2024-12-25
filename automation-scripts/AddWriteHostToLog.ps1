param (
    [string]$folderPath = "C:\Path\To\Your\Scripts"
)

# Function to modify scripts in the folder
function Add-WriteHost {
    param (
        [string]$filePath
    )

    # Read the script content
    $content = Get-Content -Path $filePath

    # Find all Write-Log commands and add corresponding Write-Host
    $modifiedContent = $content | ForEach-Object {
        if ($_ -match 'Write-Log\s*\((.*)\)') {
            $logString = $matches[1].Trim()
            # Create the corresponding Write-Host line
            $writeHostLine = "Write-Host $logString"
            # Add the Write-Host line before Write-Log
            "$writeHostLine`r`n$_"
        } else {
            $_
        }
    }

    # Write the modified content back to the file
    Set-Content -Path $filePath -Value $modifiedContent
    Write-Output "Modified script: $filePath"
}

# Get all PowerShell script files in the folder (including subfolders)
$scriptFiles = Get-ChildItem -Path $folderPath -Recurse -Filter *.ps1

# Modify each script
foreach ($scriptFile in $scriptFiles) {
    Add-WriteHost -filePath $scriptFile.FullName
}
