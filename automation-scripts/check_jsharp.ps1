# Get installed programs from the registry (32-bit and 64-bit)
$installedPrograms = @(
    Get-ItemProperty "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*" -ErrorAction SilentlyContinue |
    Select-Object DisplayName, DisplayVersion, Publisher, InstallLocation, InstallDate
    Get-ItemProperty "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*" -ErrorAction SilentlyContinue |
    Select-Object DisplayName, DisplayVersion, Publisher, InstallLocation, InstallDate
)

# Filter and display all installed programs
$installedPrograms | Where-Object { $_.DisplayName -ne $null } | Sort-Object DisplayName | Format-Table -AutoSize

# Check specifically if Visual J# Redistributable is installed
$jSharp = $installedPrograms | Where-Object { $_.DisplayName -match "J#|JSharp|Visual J#" }
if ($jSharp) {
    Write-Host "`nVisual J# Redistributable is installed:" -ForegroundColor Green
    $jSharp | Format-Table -AutoSize
} else {
    Write-Host "`nVisual J# Redistributable is NOT installed." -ForegroundColor Red
}
