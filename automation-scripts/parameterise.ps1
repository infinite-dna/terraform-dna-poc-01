# Load configuration from a file
$config = Get-Content "config.ini" -ErrorAction SilentlyContinue | ConvertFrom-StringData

# Define default values
$defaultConfig = @{
    Parameter1 = "Default1"
    Parameter2 = 42
}

# Merge default and loaded configurations
$config = $defaultConfig + $config

# Access configuration values
$Parameter1 = $config.Parameter1
$Parameter2 = $config.Parameter2

# Use $Parameter1 and $Parameter2 in your script
Write-Host "Parameter 1: $Parameter1"
Write-Host "Parameter 2: $Parameter2"
 
