# Read the content of the INI file
$iniContent = Get-Content "config.ini"

# Initialize variables to store current section
$currentSection = ""
$inSection = $false

# Loop through each line of the INI content
foreach ($line in $iniContent) {
    # Check if line contains a section header
    if ($line -match '^\[(.*?)\]$') {
        # Set current section
        $currentSection = $matches[1]
        $inSection = $true
    }
    # Check if line contains a key-value pair
    elseif ($line -match '^(.*?)=(.*)$' -and $inSection) {
        # Extract key and value
        $key = $matches[1].Trim()
        $value = $matches[2].Trim()
        
        # Print section and key-value pair
        Write-Output "[$currentSection] $key = $value"
    }
}

