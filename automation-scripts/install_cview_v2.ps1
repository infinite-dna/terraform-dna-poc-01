# Arguments for starting the process
$cviewargs = "Install c:\TEMP\PARAMS.XML"

# Start the external process
START-Process -FilePath "C:\abc.exe" -ArgumentList $cviewargs

# Add required .NET assemblies
Add-Type -AssemblyName Microsoft.VisualBasic
Add-Type -AssemblyName System.Windows.Forms

# Add user32.dll to access FindWindow and SetForegroundWindow
Add-Type @"
    using System;
    using System.Runtime.InteropServices;

    public class User32 {
        [DllImport("user32.dll", SetLastError = true)]
        public static extern IntPtr FindWindow(string lpClassName, string lpWindowName);

        [DllImport("user32.dll")]
        public static extern bool SetForegroundWindow(IntPtr hWnd);
    }
"@

# Specify the window title to find
$title = "title1"

# Initialize timeout variables
$timeoutSeconds = 30 # Maximum wait time in seconds
$pollInterval = 1    # Check every second
$elapsedTime = 0     # Track elapsed time

# Wait for the window to appear, or timeout
$hwnd = [IntPtr]::Zero
while (($hwnd -eq [IntPtr]::Zero) -and ($elapsedTime -lt $timeoutSeconds)) {
    # Try to find the window
    $hwnd = [User32]::FindWindow($null, $title)
    
    # If not found, wait and increase elapsed time
    if ($hwnd -eq [IntPtr]::Zero) {
        Start-Sleep -Seconds $pollInterval
        $elapsedTime += $pollInterval
    }
}

# Check if the window was found or if we timed out
if ($hwnd -eq [IntPtr]::Zero) {
    Write-Host "Window with title '$title' not found after $timeoutSeconds seconds."
} else {
    # Bring the window to the foreground
    [User32]::SetForegroundWindow($hwnd)

    # Send the Enter key to the window
    [System.Windows.Forms.SendKeys]::SendWait("{ENTER}")
}
