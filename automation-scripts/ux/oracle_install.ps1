# Validate C:\Oraclex64 directory exists
$Oraclex64Path = "C:\Oraclex64"
if (-not (Test-Path -Path $Oraclex64Path -PathType Container)) {
    New-Item -Path $Oraclex64Path -ItemType Directory
}

# Validate C:\Oraclex86 directory exists
$Oraclex86Path = "C:\Oraclex86"
if (-not (Test-Path -Path $Oraclex86Path -PathType Container)) {
    New-Item -Path $Oraclex86Path -ItemType Directory
}

# Validate C:\tns_admin directory exists
$TNSAdminPath = "C:\tns_admin"
if (-not (Test-Path -Path $TNSAdminPath -PathType Container)) {
    New-Item -Path $TNSAdminPath -ItemType Directory
}

# Update TNS_Admin environment variable
[Environment]::SetEnvironmentVariable("TNS_Admin", "C:\TNS_Admin", [System.EnvironmentVariableTarget]::Machine)

# Append OracleX64 values to PATH environment variable
$oldPath = [Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::Machine)
$newPath = $oldPath + ";C:\Oraclex64;C:\Oraclex64\bin"
[Environment]::SetEnvironmentVariable("Path", $newPath, [System.EnvironmentVariableTarget]::Machine)

# Create SQLnet.ora file for Oraclex86 directory
$SQLnetOraclex86Content = @"
##SQLNET.AUTHENTICATION_SERVICES = (NONE)
SQLNET.ALLOWED_LOGON_VERSION=11
##SQLNET.AUTHENTICATION_SERVICES = (NTS)
SQLNET.INBOUND_CONNECT_TIMEOUT = 120
NAMES.DIRECTORY_PATH =(TNSNAMES, HOSTNAME)
NAMES.DEFAULT_DOMAIN = WORLD
NAMES.DEFAULT_ZONE = WORLD
TRACE_LEVEL_CLIENT = OFF
AUTOMATIC_IPC = OFF
"@
$SQLnetOraclex86Path = "C:\Oraclex86\sqlnet.ora"
Set-Content -Path $SQLnetOraclex86Path -Value $SQLnetOraclex86Content

# Create SQLnet.ora file for Oraclex64 directory
$SQLnetOraclex64Content = @"
##SQLNET.AUTHENTICATION_SERVICES = (NONE)
SQLNET.ALLOWED_LOGON_VERSION=11
##SQLNET.AUTHENTICATION_SERVICES = (NTS)
SQLNET.INBOUND_CONNECT_TIMEOUT = 120
NAMES.DIRECTORY_PATH =(TNSNAMES, HOSTNAME)
NAMES.DEFAULT_DOMAIN = WORLD
NAMES.DEFAULT_ZONE = WORLD
TRACE_LEVEL_CLIENT = OFF
AUTOMATIC_IPC = OFF
"@
$SQLnetOraclex64Path = "C:\Oraclex64\sqlnet.ora"
Set-Content -Path $SQLnetOraclex64Path -Value $SQLnetOraclex64Content

# Create SQLnet.ora file for tns_admin directory
$SQLnetTNSAdminContent = @"
##SQLNET.AUTHENTICATION_SERVICES = (NONE)
SQLNET.ALLOWED_LOGON_VERSION=11
##SQLNET.AUTHENTICATION_SERVICES = (NTS)
SQLNET.INBOUND_CONNECT_TIMEOUT = 120
NAMES.DIRECTORY_PATH =(TNSNAMES, HOSTNAME)
NAMES.DEFAULT_DOMAIN = WORLD
NAMES.DEFAULT_ZONE = WORLD
TRACE_LEVEL_CLIENT = OFF
AUTOMATIC_IPC = OFF
"@
$SQLnetTNSAdminPath = "C:\tns_admin\sqlnet.ora"
Set-Content -Path $SQLnetTNSAdminPath -Value $SQLnetTNSAdminContent

# Create TNSNames file for Oraclex86 directory
$TNSNamesOraclex86Content = @"
DNABK01.WORLD =
    (DESCRIPTION=
        (FAILOVER=ON)
        (LOAD_BALANCE=OFF)
            (ADDRESS_LIST=
                (ADDRESS=(PROTOCOL=TCP)(HOST=10.155.189.181)(PORT=1521))
                (ADDRESS=(PROTOCOL=TCP)(HOST=10.155.189.180)(PORT=1521))
            )
            (CONNECT_DATA=
                (SERVER=DEDICATED)
                (SERVICE_NAME=PRIMARY)
                (FAILOVER_MODE=
                    (TYPE=SESSION)
                    (METHOD=BASIC)
                    (RETRIES=300)
                    (DELAY=1)
                )
            )
"@    
$TNSNamesOraclex86Path = "C:\Oraclex86\tnsnames.ora"
Set-Content -Path $TNSNamesOraclex86Path -Value $TNSNamesOraclex86Content

# Create TNSNames file for Oraclex64 directory
$TNSNamesOraclex64Content = @"
DNABK01.WORLD =
    (DESCRIPTION=
        (FAILOVER=ON)
        (LOAD_BALANCE=OFF)
            (ADDRESS_LIST=
                (ADDRESS=(PROTOCOL=TCP)(HOST=10.155.189.181)(PORT=1521))
                (ADDRESS=(PROTOCOL=TCP)(HOST=10.155.189.180)(PORT=1521))
            )
            (CONNECT_DATA=
                (SERVER=DEDICATED)
                (SERVICE_NAME=PRIMARY)
                (FAILOVER_MODE=
                    (TYPE=SESSION)
                    (METHOD=BASIC)
                    (RETRIES=300)
                    (DELAY=1)
                )
            )
"@    
$TNSNamesOraclex64Path = "C:\Oraclex64\tnsnames.ora"
Set-Content -Path $TNSNamesOraclex64Path -Value $TNSNamesOraclex64Content

# Create TNSNames file for tns_Admin directory
$TNSNamesTNSAdminContent = @"
DNABK01.WORLD =
    (DESCRIPTION=
        (FAILOVER=ON)
        (LOAD_BALANCE=OFF)
            (ADDRESS_LIST=
                (ADDRESS=(PROTOCOL=TCP)(HOST=10.155.189.181)(PORT=1521))
                (ADDRESS=(PROTOCOL=TCP)(HOST=10.155.189.180)(PORT=1521))
            )
            (CONNECT_DATA=
                (SERVER=DEDICATED)
                (SERVICE_NAME=PRIMARY)
                (FAILOVER_MODE=
                    (TYPE=SESSION)
                    (METHOD=BASIC)
                    (RETRIES=300)
                    (DELAY=1)
                )
            )
"@    
$TNSNamesTNSAdminPath = "C:\tns_admin\tnsnames.ora"
Set-Content -Path $TNSNamesTNSAdminPath -Value $TNSNamesTNSAdminContent
