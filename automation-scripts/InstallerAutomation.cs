using System;
using System.Threading;
using System.Windows.Automation;

public class InstallerAutomation
{
    public static void RunInstallerAutomation(string exePath)
    {
        // Start the installer process
        System.Diagnostics.Process.Start(exePath);

        // Wait for the installer window to load
        Thread.Sleep(5000);

        // Step 1: Select Financial Institution and Click Next
        var mainWindow = WaitForWindow("CRM/BI Suite 24.2.0 Installer");

        // Select "Financial Institution" radio button
        var financialInstitutionRadio = FindElementByName(mainWindow, "Financial Institution");
        InvokeControl(financialInstitutionRadio);

        // Click "Next" button
        var nextButton = FindElementByName(mainWindow, "Next");
        InvokeControl(nextButton);

        // Step 2: Handle the popup
        Thread.Sleep(2000); // Wait for the popup window
        var popupWindow = WaitForWindow("CRM/BI Suite 24.2.0 Installer");
        var okButton = FindElementByName(popupWindow, "OK");
        InvokeControl(okButton);

        // Step 3: Enter CRM/BI Suite Web Site details
        Thread.Sleep(2000); // Wait for the main installer window to become active again

        // Select "Default web site" from the dropdown
        var dropdown = FindElementByName(mainWindow, "Select the CRM/BI Suite Web Site");
        SetDropdownValue(dropdown, "Default web site");

        // Enter "cview" into CRM/BI Suite Virtual Directory
        var virtualDirTextbox = FindElementByName(mainWindow, "Enter the value of the CRM/BI Suite Virtual Directory");
        SetText(virtualDirTextbox, "cview");

        // Enter "cview-web" into CRM/BI Suite Web Service Name
        var webServiceTextbox = FindElementByName(mainWindow, "Enter the value of the CRM/BI Suite Web Service name");
        SetText(webServiceTextbox, "cview-web");

        // Click "Next"
        InvokeControl(nextButton);

        // Step 4: Select Database Type
        Thread.Sleep(2000); // Wait for the database selection screen
        var oracleRadio = FindElementByName(mainWindow, "Oracle");
        InvokeControl(oracleRadio);

        // Click "Next"
        InvokeControl(nextButton);

        // Step 5: Enter Database Details
        Thread.Sleep(2000); // Wait for the database details screen
        SetText(FindElementByName(mainWindow, "Database server Name or IP Address"), "10.148.142.17");
        SetText(FindElementByName(mainWindow, "Database server port"), "1521");
        SetText(FindElementByName(mainWindow, "Database Name(Should Match TNSNames)"), "CRMBI");
        SetText(FindElementByName(mainWindow, "Database Admin User Name"), "sys");
        SetText(FindElementByName(mainWindow, "Database Admin Password"), "C0mm0n#112233");

        // Click "Next"
        InvokeControl(nextButton);
    }

    private static AutomationElement WaitForWindow(string windowTitle)
    {
        AutomationElement window = null;
        while (window == null)
        {
            window = AutomationElement.RootElement.FindFirst(
                TreeScope.Children,
                new PropertyCondition(AutomationElement.NameProperty, windowTitle));
            Thread.Sleep(500);
        }
        return window;
    }

    private static AutomationElement FindElementByName(AutomationElement parent, string name)
    {
        return parent.FindFirst(TreeScope.Descendants, new PropertyCondition(AutomationElement.NameProperty, name));
    }

    private static void InvokeControl(AutomationElement control)
    {
        if (control == null) throw new Exception("Control not found.");
        var invokePattern = control.GetCurrentPattern(InvokePattern.Pattern) as InvokePattern;
        invokePattern?.Invoke();
    }

    private static void SetText(AutomationElement textbox, string value)
    {
        if (textbox == null) throw new Exception("Textbox not found.");
        var valuePattern = textbox.GetCurrentPattern(ValuePattern.Pattern) as ValuePattern;
        valuePattern?.SetValue(value);
    }

    private static void SetDropdownValue(AutomationElement dropdown, string value)
    {
        if (dropdown == null) throw new Exception("Dropdown not found.");
        var expandCollapsePattern = dropdown.GetCurrentPattern(ExpandCollapsePattern.Pattern) as ExpandCollapsePattern;
        expandCollapsePattern?.Expand();

        var item = dropdown.FindFirst(TreeScope.Descendants, new PropertyCondition(AutomationElement.NameProperty, value));
        InvokeControl(item);
        expandCollapsePattern?.Collapse();
    }
}
