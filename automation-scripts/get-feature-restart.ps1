# Check for pending restarts
$PendingRestart = Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending' -ErrorAction SilentlyContinue
if ($PendingRestart) {
    Write-Host "A system restart is pending due to Component Based Servicing."
}

$PendingRestart = Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired' -ErrorAction SilentlyContinue
if ($PendingRestart) {
    Write-Host "A system restart is pending due to Windows Update."
}

$PendingRestart = Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager' -Name PendingFileRenameOperations -ErrorAction SilentlyContinue
if ($PendingRestart) {
    Write-Host "A system restart is pending due to file rename operations."
}
 
