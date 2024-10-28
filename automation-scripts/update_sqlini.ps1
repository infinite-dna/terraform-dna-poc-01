param (
    [string]$basePath = "C:\dna\temp"
)

# Define file paths based on the base path parameter
$runtimeConfigPath = Join-Path -Path $basePath -ChildPath "dna\runtimeconfig.ini"
$sqlConfigPath = Join-Path -Path $basePath -ChildPath "SQL.ini"

# Read the runtimeconfig.ini file and get the DNADBName property value
$runtimeConfig = Get-Content -Path $runtimeConfigPath | ForEach-Object {
    if ($_ -match '^\s*DNADBName\s*=\s*(.+)$') { $matches[1] }
}
$DNADBName = $runtimeConfig | Select-Object -First 1

# Check if DNADBName value was found
if ($DNADBName -eq $null) {
    Write-Output "DNADBName property not found in runtimeconfig.ini"
    exit
}

# Prepare the new value for RemoteDBName
$remoteDBNameValue = "$DNADBName,@$DNADBName"

# Read the SQL.ini file
$sqlConfig = Get-Content -Path $sqlConfigPath

# Update or add RemoteDBName property
$sqlConfig = $sqlConfig | ForEach-Object {
    if ($_ -match '^\s*RemoteDBName\s*=') {
        # Update the line with new value
        "RemoteDBName=$remoteDBNameValue"
    } else {
        # Keep existing lines
        $_
    }
}

# Check if RemoteDBName was not in the file, add it
if ($sqlConfig -notcontains "RemoteDBName=$remoteDBNameValue") {
    $sqlConfig += "RemoteDBName=$remoteDBNameValue"
}

# Save the updated content back to SQL.ini
$sqlConfig | Set-Content -Path $sqlConfigPath

Write-Output "RemoteDBName updated in SQL.ini with value: $remoteDBNameValue"
