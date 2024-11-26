# Define the log folder and log file
$logFolder = "C:\cview\logs"
$logFile = Join-Path $logFolder "install_script_log.txt"

# Create log folder if it doesn't exist
if (!(Test-Path $logFolder)) {
    New-Item -Path $logFolder -ItemType Directory | Out-Null
}

# Log function
function Write-Log {
    param ([string]$message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content -Path $logFile -Value "$timestamp - $message"
}

# Start logging
Write-Log "Script execution started."

# Step 1: Install IIS
try {
    if (!(Get-WindowsFeature -Name Web-Server).Installed) {
        Install-WindowsFeature -Name Web-Server -IncludeManagementTools -Verbose
        Write-Log "IIS installed successfully."
    } else {
        Write-Log "IIS is already installed."
    }
} catch {
    Write-Log "Error installing IIS: $_"
}

# Step 2: Install IIS Features
try {
    $features = @(
        "Web-Common-Http",
        "Web-Health",
        "Web-Performance",
        "Web-Security",
        "Web-App-Dev",
        "Web-Mgmt-Tools"
    )

    foreach ($feature in $features) {
        Install-WindowsFeature -Name $feature -IncludeAllSubFeature -Verbose
    }
    Write-Log "IIS features installed successfully."
} catch {
    Write-Log "Error installing IIS features: $_"
}

# Step 3: Install .NET Framework 4.8
try {
    $dotNetInstaller = "C:\cview\temp\prreq\ndp48-x86-x64-allos-enu.exe"

    if (Test-Path $dotNetInstaller) {
        Start-Process -FilePath $dotNetInstaller -ArgumentList "/quiet /norestart" -Wait
        Write-Log ".NET Framework 4.8 installed successfully."
    } else {
        Write-Log "Error: .NET Framework installer not found at $dotNetInstaller."
    }
} catch {
    Write-Log "Error installing .NET Framework 4.8: $_"
}

# Step 4: Install Oracle Client 19c
try {
    $oracleClientInstaller = "C:\cview\temp\prreq\oracle19c_setup.exe" # Replace with actual file name if needed

    if (Test-Path $oracleClientInstaller) {
        Start-Process -FilePath $oracleClientInstaller -ArgumentList "/silent /norestart" -Wait -Verb RunAs
        Write-Log "Oracle Client 19c installed successfully."
    } else {
        Write-Log "Error: Oracle Client installer not found at $oracleClientInstaller."
    }
} catch {
    Write-Log "Error installing Oracle Client 19c: $_"
}

# Step 5: Register Oracle DLLs in GAC
try {
    $oracleBinPath = "C:\app19c\client\aatyagi\product\19.0.0\client_1\ODP.NET\bin\4"
    $policyPath = "C:\app19c\client\aatyagi\product\19.0.0\client_1\ODP.NET\PublisherPolicy\4"

    Start-Process -FilePath "$oracleBinPath\OraProvCfg.exe" -ArgumentList "/action:gac /providerpath:Oracle.DataAccess.dll" -Wait -NoNewWindow
    Start-Process -FilePath "$oracleBinPath\OraProvCfg.exe" -ArgumentList "/action:gac /providerpath:`"$policyPath\Policy.4.121.Oracle.DataAccess.dll`"" -Wait -NoNewWindow
    Write-Log "Oracle DLLs registered in GAC successfully."
} catch {
    Write-Log "Error registering Oracle DLLs in GAC: $_"
}

# Step 6: Set up tnsnames.ora and sqlnames.ora
try {
    $tnsnamesPath = "C:\app19c\client\aatyagi\product\19.0.0\client_1\network\admin\tnsnames.ora"
    $sqlnamesPath = "C:\app19c\client\aatyagi\product\19.0.0\client_1\network\admin\sqlnames.ora"

    Set-Content -Path $tnsnamesPath -Value @"
# tnsnames.ora content
YOUR_TNS_ENTRIES_HERE
"@ -Force

    Set-Content -Path $sqlnamesPath -Value @"
# sqlnames.ora content
YOUR_SQLNAMES_ENTRIES_HERE
"@ -Force

    Write-Log "tnsnames.ora and sqlnames.ora configured successfully."
} catch {
    Write-Log "Error setting up tnsnames.ora and sqlnames.ora: $_"
}

# Step 7: Install Visual J# 64-bit
try {
    $vjSharpInstaller = "C:\cview\temp\prreq\vjredist64.exe"

    if (Test-Path $vjSharpInstaller) {
        Start-Process -FilePath $vjSharpInstaller -ArgumentList "/quiet /norestart" -Wait
        Write-Log "Visual J# 64-bit installed successfully."
    } else {
        Write-Log "Error: Visual J# installer not found at $vjSharpInstaller."
    }
} catch {
    Write-Log "Error installing Visual J# 64-bit: $_"
}

# Script execution completed
Write-Log "Script execution completed."
