# Connect to Azure
Connect-AzAccount

# Define variables
$resourceGroupName = "YourResourceGroup"
$instanceName = "YourManagedInstanceName"
$location = "YourLocation"
$vCores = 8  # Number of vCores
$storageSizeGB = 1000  # Storage size in GB

# Create SQL Managed Instance
New-AzSqlInstance -ResourceGroupName $resourceGroupName `
                  -Name $instanceName `
                  -Location $location `
                  -VCore $vCores `
                  -LicenseType LicenseIncluded `
                  -StorageSizeInGB $storageSizeGB
