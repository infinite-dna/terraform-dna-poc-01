# Define variables
$xmlPath = "initialdataencryption\resource\InitiaDataEncryptionField.xml"
$exePath = "./../initialDataEncryption.exe"
$utilityFolder = "initialdataencryption\utility_cmd"
$dbConnection = "dbserver:port/dbname"
$username = "osibank"
$password = "osibank"
$passnumber = 1

# Create the utility_cmd folder if it doesn't exist
if (!(Test-Path -Path $utilityFolder)) {
    New-Item -ItemType Directory -Path $utilityFolder | Out-Null
}

# Load the XML file
[xml]$xmlContent = Get-Content -Path $xmlPath

# Loop through each FIELDGROUP and create batch files
foreach ($fieldGroup in $xmlContent.XML.FIELDGROUPS.FIELDGROUP) {
    $fieldGroupName = $fieldGroup.NAME
    $batchFileName = "$utilityFolder\$fieldGroupName`_$passnumber.bat"
    $batchContent = "$exePath $dbConnection $username $password $passnumber $fieldGroupName"

    # Create the batch file with content
    Set-Content -Path $batchFileName -Value $batchContent
}

Write-Host "Batch files created successfully in $utilityFolder"
