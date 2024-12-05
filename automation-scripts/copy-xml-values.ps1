# Load Source and Destination XML Files
[xml]$sourceXml = Get-Content -Path "path\to\source.xml"
[xml]$destXml = Get-Content -Path "path\to\destination.xml"

# Define a recursive function to update the destination XML with values from the source
function Update-XmlValues {
    param (
        [xml]$sourceNode,
        [xml]$destNode
    )

    foreach ($child in $sourceNode.ChildNodes) {
        # Find the corresponding node in the destination XML
        $matchingNode = $destNode.SelectSingleNode($child.Name)

        if ($matchingNode) {
            if ($child.HasChildNodes -and $child.ChildNodes.Count -gt 1) {
                # If the child node has children (complex structure), recurse
                Update-XmlValues -sourceNode $child -destNode $matchingNode
            } else {
                # Update the value in the destination XML
                $matchingNode.InnerText = $child.InnerText
            }
        }
    }
}

# Start updating the destination XML
Update-XmlValues -sourceNode $sourceXml.DocumentElement -destNode $destXml.DocumentElement

# Save the updated destination XML
$destXml.Save("path\to\updated_destination.xml")

Write-Output "Destination XML has been updated successfully."
