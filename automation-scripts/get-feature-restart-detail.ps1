# Retrieve PendingFileRenameOperations value
$PendingFileRename = Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager' -Name PendingFileRenameOperations -ErrorAction SilentlyContinue

# Convert binary data to a readable format
if ($PendingFileRename -ne $null) {
    $Bytes = [byte[]]$PendingFileRename.PendingFileRenameOperations
    $RenamedFiles = @()
    for ($i = 0; $i -lt $Bytes.Length; $i += 2) {
        $RenamedFiles += [System.Text.Encoding]::Unicode.GetString($Bytes[$i..($i + 1)])
    }
    Write-Output "Files pending rename:"
    $RenamedFiles
} else {
    Write-Output "No pending file rename operations."
}
 
