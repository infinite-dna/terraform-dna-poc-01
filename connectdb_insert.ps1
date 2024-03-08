# Load the Oracle Managed Data Access assembly
Add-Type -Path "C:\path\to\Oracle.ManagedDataAccess.dll"

# Connection string
$connectionString = "User Id=<username>;Password=<password>;Data Source=<datasource>"

# SQL query for insertion
$insertQuery = "INSERT INTO your_table (column1, column2) VALUES (:value1, :value2)"

# Create Oracle connection object
$connection = New-Object Oracle.ManagedDataAccess.Client.OracleConnection($connectionString)

try {
    # Open the connection
    $connection.Open()

    # Create Oracle command object
    $command = New-Object Oracle.ManagedDataAccess.Client.OracleCommand
    $command.Connection = $connection
    $command.CommandText = $insertQuery

    # Set parameter values
    $value1 = "example_value1"
    $value2 = "example_value2"
    $command.Parameters.AddWithValue(":value1", $value1)
    $command.Parameters.AddWithValue(":value2", $value2)

    # Execute the insertion command
    $rowsAffected = $command.ExecuteNonQuery()

    Write-Host "Rows inserted: $rowsAffected"
}
catch {
    Write-Host "Error occurred: $_.Exception.Message"
}
finally {
    # Close the connection
    if ($connection.State -eq 'Open') {
        $connection.Close()
    }
}
 
