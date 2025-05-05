$completedFilesPath = "completedFiles.ini"

function Is-FileNew {
    param (
        [string]$fileName
    )

    if (!(Test-Path $completedFilesPath)) {
        # If file doesn't exist, it's new by default
        return $true
    }

    $completedFiles = Get-Content $completedFilesPath
    return -not ($completedFiles -contains $fileName)
}

function Add-FileToCompleted {
    param (
        [string]$fileName
    )

    Add-Content -Path $completedFilesPath -Value $fileName
}
