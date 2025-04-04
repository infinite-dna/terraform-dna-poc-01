# Nexus credentials
$username = "admin"
$password = "admin123"

# Nexus base URL and search parameters
$nexusUrl = "http://<nexus-host>:8081"
$repository = "my-repo"
$fileName = "myapp.zip"

# Construct the full API URL
$searchUrl = "$nexusUrl/service/rest/v1/search/assets?repository=$repository&name=$fileName"

# Make the API request
$response = Invoke-RestMethod -Uri $searchUrl -Method Get -Authentication Basic -Credential (New-Object System.Management.Automation.PSCredential($username,(ConvertTo-SecureString $password -AsPlainText -Force)))

# Display the results
$response.items | ForEach-Object {
    Write-Host "Download URL: $($_.downloadUrl)"
    Write-Host "Path: $($_.path)"
    Write-Host "Repository: $($_.repository)"
    Write-Host "----------------------------------"
}
