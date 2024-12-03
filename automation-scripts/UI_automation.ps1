# Load the UIAutomationClient assembly
Add-Type -AssemblyName UIAutomationClient

# Use the root AutomationElement to start exploring UI elements
$rootElement = [System.Windows.Automation.AutomationElement]::RootElement

# Find a specific window (e.g., Notepad)
$condition = [System.Windows.Automation.Condition]::TrueCondition
$notepad = $rootElement.FindFirst([System.Windows.Automation.TreeScope]::Children, $condition)

# Output the found window (if any)
$notepad.Current.Name

[Reflection.Assembly]::LoadWithPartialName("UIAutomationClient").GetTypes()
