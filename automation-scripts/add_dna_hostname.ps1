# Define paths for the ini file, hosts file, and log directory
$iniFilePath = "C:\DNAUX\Temp\runtimeconfig.ini"
$hostsFilePath = "C:\Windows\System32\drivers\etc\hosts"
$logDirectory = "C:\DNAUX\Logs"
$logFilePath = "$logDirectory\adddnahost.log"

# Ensure the log directory exists, create if not
if (-not (Test-Path $logDirectory)) {
    New-Item -Path $logDirectory -ItemType Directory | Out-Null
}

# Function to write log messages with timestamp
function Write-Log {
    param ([string]$message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "$timestamp`t$message"
    Add-Content -Path $logFilePath -Value $logMessage
}

# Log the start of the script
Write-Log "Script started."

# Check if the INI file exists
if (-not (Test-Path $iniFilePath)) {
    Write-Log "Error: INI file not found at $iniFilePath"
    # Commenting out exit to allow script to proceed without file
    # exit 1
}

# Read the INI file content
$iniContent = Get-Content -Path $iniFilePath

# Initialize variables for DNAServerHostname and DNAServerIP
$DNAServerHostname = ""
$DNAServerIP = ""

# Loop through the INI file content and extract the required fields
foreach ($line in $iniContent) {
    if ($line -match "^DNAServerHostname\s*=\s*(.*)") {
        $DNAServerHostname = $matches[1].Trim()
    }
    elseif ($line -match "^DNAServerIP\s*=\s*(.*)") {
        $DNAServerIP = $matches[1].Trim()
    }
}

# Verify that both DNAServerHostname and DNAServerIP were found
if (-not ($DNAServerHostname -and $DNAServerIP)) {
    Write-Log "Error: DNAServerHostname or DNAServerIP not found in the INI file."
    # Commenting out exit to prevent script from stopping here
    # exit 1
}

# Log the values extracted from the INI file
Write-Log "DNAServerHostname: $DNAServerHostname"
Write-Log "DNAServerIP: $DNAServerIP"

# Check if the entry already exists in the hosts file
$existingEntry = Select-String -Path $hostsFilePath -Pattern "$DNAServerIP\s+$DNAServerHostname"

if ($existingEntry) {
    Write-Log "The host entry already exists in the hosts file."
} else {
    # Create the new entry to add
    $newEntry = "$DNAServerIP`t$DNAServerHostname"

    # Try adding the new entry to the hosts file
    try {
        Add-Content -Path $hostsFilePath -Value $newEntry
        Write-Log "The host entry ($DNAServerIP $DNAServerHostname) has been added successfully."
    } catch {
        Write-Log "Error: Failed to add the host entry to the hosts file. $_"
    }
}

# Log the end of the script
Write-Log "Script ended."
