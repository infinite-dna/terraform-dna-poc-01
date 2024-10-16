# Define the path to your XML file
$xmlFilePath = "C:\path\to\your\config.xml"

# Load the XML file
[xml]$xmlContent = Get-Content $xmlFilePath

# Get the current machine name
$currentMachineName = $env:COMPUTERNAME

# Function to replace machine name in the URL
function Update-MachineNameInUrl {
    param (
        [string]$url,
        [string]$newMachineName
    )

    # Use regex to replace the machine name part of the URL, keeping the port and other parts intact
    return $url -replace 'http(s?)://[^:/]+', "http$1://$newMachineName"
}

# List of URL fields to update
$urlFields = @('logtraceurl', 'platformserviceurl', 'logexceptionurl', 'safurl', 'ststokenurl')

# Iterate through each URL field in the XML and update the machine name
foreach ($field in $urlFields) {
    $fieldElement = $xmlContent.configuration.appSettings.add | Where-Object { $_.key -eq $field }

    if ($fieldElement) {
        # Get the current URL from the XML
        $currentUrl = $fieldElement.value
        
        # Update the URL with the new machine name
        $updatedUrl = Update-MachineNameInUrl -url $currentUrl -newMachineName $currentMachineName
        
        # Set the updated URL back in the XML
        $fieldElement.value = $updatedUrl
    }
}

# Save the updated XML back to the file
$xmlContent.Save($xmlFilePath)

Write-Output "XML file updated successfully with the current machine name: $currentMachineName"
