# Arguments for starting the process
$cviewargs = "Install c:\TEMP\PARAMS.XML"

# Start the external process
START-Process -FilePath "C:\abc.exe" -ArgumentList $cviewargs
start-sleep 2

# Add required .NET assemblies
Add-Type -AssemblyName Microsoft.VisualBasic
Add-Type -AssemblyName System.Windows.Forms

# Add user32.dll to access FindWindow
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

# Find the window handle
$hwnd = [User32]::FindWindow($null, $title)

# Check if the window was found
if ($hwnd -eq [IntPtr]::Zero) {
    Write-Host "Window with title '$title' not found."
} else {
    # Bring the window to the foreground
    [User32]::SetForegroundWindow($hwnd)

    # Send the Enter key to the window
    [System.Windows.Forms.SendKeys]::SendWait("{ENTER}")
}
