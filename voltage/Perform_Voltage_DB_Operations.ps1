# Define Database Connection Variables
$dbserver = "your_db_server"
$dbport = "your_db_port"
$username = "your_username"
$password = "your_password"
$database = "your_db_service"

# Define Log File
$logFile = "C:\Logs\db_update.log"

# Define Oracle DLL Path
$oracleDllPath = "C:\Voltage\temp\prereq\Oracle.ManagedDataAccess.dll"

# Function to Log Messages
function Write-Log {
    param ([string]$message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$timestamp : $message" | Out-File -Append -FilePath $logFile
    Write-Host "$timestamp : $message"
}

# Load Oracle Data Provider
Add-Type -Path $oracleDllPath

# Create Connection String
$connectionString = "User Id=$username;Password=$password;Data Source=(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=$dbserver)(PORT=$dbport))(CONNECT_DATA=(SERVICE_NAME=$database)));"

try {
    # Open Database Connection
    $connection = New-Object Oracle.ManagedDataAccess.Client.OracleConnection($connectionString)
    $connection.Open()
    Write-Log "Connected to the database successfully."

    # Check BANKOPTIONVALUE for SDCP
    $querySDCP = "SELECT BANKOPTIONVALUE FROM bankoption WHERE bankoptioncd = 'SDCP'"
    $command = $connection.CreateCommand()
    $command.CommandText = $querySDCP
    $bankOptionValueSDCP = $command.ExecuteScalar()
    
    if ($bankOptionValueSDCP.ToUpper() -ne "NONE") {
        Write-Log "SDCP value is '$bankOptionValueSDCP', not 'none'. Exiting the script."
        $connection.Close()
        exit 1
    }
    Write-Log "SDCP value is '$bankOptionValueSDCP'. Proceeding with updates."

    # Check current values for DC
    $queryDC = "SELECT bankoptionYN, bankOptionValue FROM bankoption WHERE bankoptioncd = 'DC'"
    $command.CommandText = $queryDC
    $reader = $command.ExecuteReader()

    $reader.Read()
    $existingBankOptionYN = $reader.GetString(0).Trim()
    $existingBankOptionValue = $reader.GetString(1).Trim()
    $reader.Close()

    # Update bankoptionYN if different
    if ($existingBankOptionYN -ne 'Y') {
        Write-Log "Updating bankoptionYN to 'Y' for DC."
        $updateYN = "UPDATE bankoption SET bankoptionYN = 'Y' WHERE bankoptioncd = 'DC'"
        $command.CommandText = $updateYN
        $command.ExecuteNonQuery()
    } else {
        Write-Log "bankoptionYN is already 'Y' for DC. No update needed."
    }

    # Update bankOptionValue if different
    if ($existingBankOptionValue -ne 'CHH') {
        Write-Log "Updating bankOptionValue to 'CHH' for DC."
        $updateValue = "UPDATE bankoption SET bankOptionValue = 'CHH' WHERE bankoptioncd = 'DC'"
        $command.CommandText = $updateValue
        $command.ExecuteNonQuery()
    } else {
        Write-Log "bankOptionValue is already 'CHH' for DC. No update needed."
    }

    # Close Connection
    $connection.Close()
    Write-Log "Script execution completed successfully."
} catch {
    Write-Log "Error: $_"
    if ($connection -and $connection.State -eq "Open") {
        $connection.Close()
    }
    exit 1
}
