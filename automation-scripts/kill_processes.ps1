param (
    [string]$folderPath = "C:\DNA"  
)

# Define the log folder and log file
$logFolder = "C:\dna\logs"
$logFile = "$logFolder\kill_processes.log"  
# Create the log folder if it doesn't exist
if (-not (Test-Path -Path $logFolder)) {
    New-Item -ItemType Directory -Path $logFolder -Force
    Add-Content -Path $logFile -Value "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - Log directory created."
}

# Function to log messages
function Log-Message {
    param (
        [string]$message
    )
    Add-Content -Path $logFile -Value "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - $message"
}

# Function to check for processes that have files open in the folder
function Get-LockingProcesses {
    param (
        [string]$folder
    )

    $lockingProcesses = @()

    # Get all running processes
    $processes = Get-Process | ForEach-Object {
        # For each process, check its modules to see if any files are within the folder
        $_.Modules | Where-Object { 
            $_.FileName -like "$folder\*" 
        } | ForEach-Object {
            # Store details of locking processes
            $lockingProcesses += [PSCustomObject]@{
                ProcessName = $_.Name
                ProcessId   = $_.BaseProcessId
                FileName    = $_.FileName
            }
        }
    }

    return $lockingProcesses
}

# Get all processes that are locking files in the specified folder
$lockingProcesses = Get-LockingProcesses -folder $folderPath

# Check if any processes are found and terminate them
if ($lockingProcesses.Count -gt 0) {
    foreach ($process in $lockingProcesses) {
        try {
            Stop-Process -Id $process.ProcessId -Force
            Log-Message "Terminated process $($process.ProcessName) (ID: $($process.ProcessId))"
        } catch {
            Log-Message "Failed to terminate process $($process.ProcessName) (ID: $($process.ProcessId))"
        }
    }
} else {
    Log-Message "No processes are using files in the folder: $folderPath"
}
