# Define the file path
$xmlFilePath = "C:\path\to\exe.config.xml"

# Define the new value
$newValue = "C:\programfiles\xyz\abc\pqr"

# Load the XML file
[xml]$xml = Get-Content -Path $xmlFilePath

# Find the <ad> element with key="mytestvalue"
$node = $xml.SelectSingleNode("//config/appsettings/ad[@key='mytestvalue']")

if ($node -ne $null) {
    # Update the value attribute
    $node.SetAttribute("value", $newValue)
    
    # Save the updated XML file
    $xml.Save($xmlFilePath)
    Write-Output "XML file updated successfully."
} else {
    Write-Output "Node with key='mytestvalue' not found in the XML file."
}
