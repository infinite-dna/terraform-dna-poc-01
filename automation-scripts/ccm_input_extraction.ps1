param (
    [string]$exeFile
)

# Check if the file exists
if (!(Test-Path $exeFile)) {
    Write-Host "File not found: $exeFile" -ForegroundColor Red
    exit 1
}

# Get the output folder (same location as EXE, named after EXE)
$extractFolder = [System.IO.Path]::Combine((Get-Item $exeFile).DirectoryName, (Get-Item $exeFile).BaseName)

# Ensure the output directory exists
if (!(Test-Path $extractFolder)) {
    New-Item -ItemType Directory -Path $extractFolder | Out-Null
}

# Try using Expand-Archive (for ZIP-based EXEs)
try {
    Expand-Archive -Path $exeFile -DestinationPath $extractFolder -Force
    Write-Host "Extraction completed using Expand-Archive!" -ForegroundColor Green
    exit 0
} catch {
    Write-Host "Expand-Archive failed (probably not a ZIP-based EXE)." -ForegroundColor Yellow
}

# Try using tar (if the EXE is a valid archive format)
try {
    tar -xf $exeFile -C $extractFolder
    Write-Host "Extraction completed using tar!" -ForegroundColor Green
    exit 0
} catch {
    Write-Host "tar extraction failed." -ForegroundColor Yellow
}

# Try built-in EXE extraction (for self-extracting EXEs)
$extractCommand = "$exeFile /extract:$extractFolder /quiet"
Write-Host "Trying built-in EXE extraction..."
Start-Process -FilePath $exeFile -ArgumentList "/extract:$extractFolder /quiet" -Wait

Write-Host "Extraction attempted using built-in methods!" -ForegroundColor Cyan
