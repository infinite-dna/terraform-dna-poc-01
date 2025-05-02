param (
    [String]$DestinationPath,
    [String]$xmlFileName,
    [String]$iniFileName
)

# Paths
$xmlFilePath = Join-Path -Path $DestinationPath -ChildPath $xmlFileName
$iniFilePath = Join-Path -Path $DestinationPath -ChildPath $iniFileName
$logFilePath = Join-Path -Path $DestinationPath -ChildPath "ParseXMLtoINI.txt"

# Ensure log directory exists
$logDir = Split-Path -Path $logFilePath
if (-not (Test-Path -Path $logDir)) {
    New-Item -Path $logDir -ItemType Directory
}

# Start logging
Start-Transcript -Path $logFilePath -Append

# Function to write to the Event Viewer
function Write-LogEvent {
    param (
        [string]$message,
        [string]$eventType = "Information"
    )
    if (-not (Get-EventLog -LogName "Application" -Source "PowerShellScript" -ErrorAction SilentlyContinue)) {
        New-EventLog -LogName "Application" -Source "PowerShellScript"
    }
    Write-EventLog -LogName "Application" -Source "PowerShellScript" -EntryType $eventType -EventId 1000 -Message $message
}

# Load XML
try {
    [xml]$xmlContent = Get-Content -Path $xmlFilePath -Raw
    Write-LogEvent -message "XML file loaded successfully from $xmlFilePath"
} catch {
    $errorMsg = "Failed to load XML file: $_"
    Write-Error $errorMsg
    Write-LogEvent -message $errorMsg -eventType "Error"
    Stop-Transcript
    exit 1
}

# Load existing INI contents into a hashtable
$iniData = @{}
if (Test-Path -Path $iniFilePath) {
    try {
        Get-Content -Path $iniFilePath | ForEach-Object {
            if ($_ -match '^\s*([^=]+?)\s*=\s*(.*)$') {
                $key = $matches[1].Trim()
                $value = $matches[2].Trim()
                $iniData[$key] = $value
            }
        }
        Write-LogEvent -message "Existing INI file loaded from $iniFilePath"
    } catch {
        $errorMsg = "Failed to read existing INI file: $_"
        Write-Error $errorMsg
        Write-LogEvent -message $errorMsg -eventType "Error"
        Stop-Transcript
        exit 1
    }
}

# Update from <Pipeline><Common>
try {
    $properties = $xmlContent.Configurations.Pipeline.Common.Property
    foreach ($property in $properties) {
        $key = $property.name
        $value = if ($property.'#cdata-section') { $property.'#cdata-section' } else { $property.value }
        $iniData[$key] = $value
    }
    Write-LogEvent -message "Processed <Pipeline><Common> section of the XML file."
} catch {
    $errorMsg = "Error processing <Pipeline><Common> section: $_"
    Write-Error $errorMsg
    Write-LogEvent -message $errorMsg -eventType "Error"
    Stop-Transcript
    exit 1
}

# Update from <Config><Settings>
try {
    $properties = $xmlContent.Config.Config.Settings.Property
    foreach ($property in $properties) {
        $key = $property.name
        $value = if ($property.'#cdata-section') { $property.'#cdata-section' } else { $property.value }
        $iniData[$key] = $value
    }
    Write-LogEvent -message "Processed <Config><Settings> section of the XML file."
} catch {
    $errorMsg = "Error processing <Config><Settings> section: $_"
    Write-Error $errorMsg
    Write-LogEvent -message $errorMsg -eventType "Error"
    Stop-Transcript
    exit 1
}

# Write updated INI content
try {
    $iniContent = $iniData.GetEnumerator() | ForEach-Object {
        "$($_.Key)=$($_.Value)"
    }
    $iniContent | Out-File -FilePath $iniFilePath -Encoding UTF8
    Write-LogEvent -message "INI file has been updated at: $iniFilePath"
    Write-Host "INI file has been updated at: $iniFilePath"
} catch {
    $errorMsg = "Failed to write INI file: $_"
    Write-Error $errorMsg
    Write-LogEvent -message $errorMsg -eventType "Error"
    Stop-Transcript
    exit 1
}

# Stop logging
Stop-Transcript
Write-LogEvent -message "Script completed successfully."
