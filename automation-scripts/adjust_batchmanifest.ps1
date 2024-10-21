# Load the XML content from a file
[xml]$xml = Get-Content -Path "C:\dna\temp\dna\DNA\webapplicationserver\nativeapps\batchmanifests.xml"

# Define the BatchItem names to move to the end
$itemsToMove = @("PDFExport.dnax", "AchPdfPrintingPackage.dnaxp")

# Find the BatchItem elements that need to be moved
$items = @()
foreach ($item in $xml.Batch.BatchItem) {
    if ($itemsToMove -contains $item.Name) {
        $items += $item
    }
}

# Remove the identified BatchItem elements from their original positions
foreach ($item in $items) {
    $xml.Batch.RemoveChild($item)
}

# Append the identified BatchItem elements at the end
foreach ($item in $items) {
    $xml.Batch.AppendChild($item)
}

# Save the modified XML back to a file
$xml.Save("C:\dna\temp\dna\DNA\webapplicationserver\nativeapps\batchmanifests.xml")
