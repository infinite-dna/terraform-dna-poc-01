using System;
using System.Diagnostics;
using System.Threading;
using System.Windows.Automation;

namespace CVIEWAutomation
{
    class Program
    {
        static void Main(string[] args)
        {
            try
            {
                // Path to the installer executable
                string exePath = @"C:\temp\srm.exe";

                Console.WriteLine("Starting the installer...");
                var process = Process.Start(exePath);
                process.WaitForInputIdle(); // Wait for the process to initialize

                // Debug: List all top-level windows
                Console.WriteLine("Listing all top-level windows...");
                ListAllTopLevelWindows();

                Console.WriteLine("Waiting for installer window...");
                var mainWindow = WaitForWindow("CRM/BI Suite 24.2.0 Installer");
                Console.WriteLine("Installer window found!");

                // Interact with the Financial Institution radio button
                var radioButton = FindElementByName(mainWindow, "Financial Institution");
                if (radioButton != null)
                {
                    var selectionPattern = radioButton.GetCurrentPattern(SelectionItemPattern.Pattern) as SelectionItemPattern;
                    selectionPattern?.Select();
                    Console.WriteLine("Successfully selected 'Financial Institution'.");
                }
                else
                {
                    throw new Exception("Radio button 'Financial Institution' not found.");
                }

                // Click the Next button
                var nextButton = FindElementByName(mainWindow, "Next");
                if (nextButton != null)
                {
                    InvokeControl(nextButton);
                    Console.WriteLine("Clicked 'Next' button.");
                }
                else
                {
                    throw new Exception("'Next' button not found.");
                }

                // Wait for popup window
                Console.WriteLine("Waiting for popup window...");
                var popupWindow = WaitForWindow("CRM/BI Suite 24.2.0 Installer");
                var okButton = FindElementByName(popupWindow, "OK");
                if (okButton != null)
                {
                    InvokeControl(okButton);
                    Console.WriteLine("Clicked 'OK' button on popup.");
                }
                else
                {
                    throw new Exception("'OK' button on popup not found.");
                }

                // Further steps would follow here...

                Console.WriteLine("Automation completed successfully.");
            }
            catch (Exception ex)
            {
                Console.WriteLine($"An error occurred: {ex.Message}");
            }

            Console.ReadLine(); // Pause console to view results
        }

        private static AutomationElement WaitForWindow(string windowTitle, int timeoutInSeconds = 30)
        {
            AutomationElement window = null;
            int elapsed = 0;

            while (window == null && elapsed < timeoutInSeconds * 1000)
            {
                window = AutomationElement.RootElement.FindFirst(
                    TreeScope.Children,
                    new PropertyCondition(AutomationElement.NameProperty, windowTitle));
                if (window == null)
                {
                    Thread.Sleep(500); // Wait for half a second before retrying
                    elapsed += 500;
                }
            }

            if (window == null)
            {
                throw new Exception($"Window with title '{windowTitle}' not found after {timeoutInSeconds} seconds.");
            }

            return window;
        }

        private static void ListAllTopLevelWindows()
        {
            var topLevelWindows = AutomationElement.RootElement.FindAll(TreeScope.Children, Condition.TrueCondition);
            foreach (AutomationElement window in topLevelWindows)
            {
                Console.WriteLine($"Window Title: {window.Current.Name}");
            }
        }

        private static AutomationElement FindElementByName(AutomationElement parent, string name)
        {
            return parent.FindFirst(
                TreeScope.Descendants,
                new PropertyCondition(AutomationElement.NameProperty, name));
        }

        private static void InvokeControl(AutomationElement control)
        {
            if (control == null) throw new Exception("Control not found.");
            var invokePattern = control.GetCurrentPattern(InvokePattern.Pattern) as InvokePattern;
            invokePattern?.Invoke();
        }

        private static void SetTextBoxValue(AutomationElement textBox, string value)
        {
            if (textBox == null) throw new Exception("Text box not found.");
            var valuePattern = textBox.GetCurrentPattern(ValuePattern.Pattern) as ValuePattern;
            valuePattern?.SetValue(value);
        }

        private static void SelectComboBoxItem(AutomationElement comboBox, string item)
        {
            if (comboBox == null) throw new Exception("Combo box not found.");
            var expandCollapsePattern = comboBox.GetCurrentPattern(ExpandCollapsePattern.Pattern) as ExpandCollapsePattern;
            expandCollapsePattern?.Expand();

            var listItem = comboBox.FindFirst(TreeScope.Subtree, new PropertyCondition(AutomationElement.NameProperty, item));
            InvokeControl(listItem);
        }
    }
}
