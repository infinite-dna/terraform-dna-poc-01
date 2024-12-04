$folderPath = "C:\Path\To\Your\Folder"

# Grant full permissions to INET_IUSR
icacls $folderPath /grant "INET_IUSR:(OI)(CI)F" /T /C
