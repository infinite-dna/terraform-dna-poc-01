# Define the file path
$xmlFilePath = "C:\path\to\exe.config.xml"

# Define the new value
$newValue = "C:\programfiles\xyz\abc\pqr"

# Load the XML file
[xml]$xml = Get-Content -Path $xmlFilePath

# Update the <mytestValue> field
$node = $xml.SelectSingleNode("//mytestValue")
if ($node -ne $null) {
    $node.InnerText = $newValue
    # Save the updated XML file
    $xml.Save($xmlFilePath)
    Write-Output "XML file updated successfully."
} else {
    Write-Output "<mytestValue> node not found in the XML file."
}
