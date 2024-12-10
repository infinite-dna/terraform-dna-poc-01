using System;
using OpenQA.Selenium.Appium;
using OpenQA.Selenium.Appium.Windows;
using OpenQA.Selenium.Support.UI;

namespace CRMInstallerAutomation
{
    class Program
    {
        private static WindowsDriver<WindowsElement> desktopSession;

        static void Main(string[] args)
        {
            try
            {
                // Initialize WinAppDriver session
                var options = new AppiumOptions();
                options.AddAdditionalCapability("app", "Root");
                desktopSession = new WindowsDriver<WindowsElement>(new Uri("http://127.0.0.1:4723"), options);

                // Start automation
                AutomateInstallation();

                Console.WriteLine("Installation completed successfully!");
            }
            catch (Exception ex)
            {
                Console.WriteLine("Automation failed: " + ex.Message);
            }
            finally
            {
                desktopSession?.Quit();
            }
        }

        private static void AutomateInstallation()
        {
            // Step 1: Select "Financial Institution" radio button
            var financialInstitutionRadio = WaitForElementByName("Financial Institution");
            financialInstitutionRadio.Click();

            // Step 2: Click "Next" button
            var nextButton = WaitForElementByName("Next");
            nextButton.Click();

            // Step 3: Handle popup window and press "OK"
            var popupOkButton = WaitForPopupAndFindElementByName("CRM/BI Suite 24.2.0 Installer", "OK");
            popupOkButton.Click();

            // Step 4: Select "Default Web Site" from dropdown
            var dropdown = WaitForElementByName("Select the CRM/BI Suite Web Site:");
            dropdown.Click();
            var defaultWebsiteOption = WaitForElementByName("Default Web Site");
            defaultWebsiteOption.Click();

            // Step 5: Enter values in text boxes
            var virtualDirectoryTextbox = WaitForElementByName("Enter the value of the CRM/BI Suite Virtual Directory");
            virtualDirectoryTextbox.SendKeys("cview");

            var webServiceNameTextbox = WaitForElementByName("Enter the value of the CRM/BI suite Web Service name");
            webServiceNameTextbox.SendKeys("cview-web");

            // Step 6: Click "Next"
            nextButton = WaitForElementByName("Next");
            nextButton.Click();

            // Step 7: Select "Oracle" radio button
            var oracleRadioButton = WaitForElementByName("Oracle");
            oracleRadioButton.Click();

            // Step 8: Click "Next"
            nextButton = WaitForElementByName("Next");
            nextButton.Click();

            // Step 9: Enter database details
            var dbServerTextbox = WaitForElementByName("Database server Name or IP Address:");
            dbServerTextbox.SendKeys("10.148.142.17");

            var dbPortTextbox = WaitForElementByName("Database server port:");
            dbPortTextbox.SendKeys("1521");

            var dbNameTextbox = WaitForElementByName("Database Name(Should Match TNSNames):");
            dbNameTextbox.SendKeys("CRMBI");

            var dbAdminUserTextbox = WaitForElementByName("Database Admin User Name:");
            dbAdminUserTextbox.SendKeys("sys");

            var dbAdminPasswordTextbox = WaitForElementByName("Database Admin Password:");
            dbAdminPasswordTextbox.SendKeys("C0mm0n#112233");

            // Step 10: Click "Next"
            nextButton = WaitForElementByName("Next");
            nextButton.Click();
        }

        // Utility: Wait for element by name
        private static WindowsElement WaitForElementByName(string name, int timeout = 10)
        {
            var wait = new WebDriverWait(desktopSession, TimeSpan.FromSeconds(timeout));
            return wait.Until(driver => driver.FindElementByName(name));
        }

        // Utility: Wait for popup and find element
        private static WindowsElement WaitForPopupAndFindElementByName(string popupTitle, string elementName, int timeout = 10)
        {
            var wait = new WebDriverWait(desktopSession, TimeSpan.FromSeconds(timeout));
            var popup = wait.Until(driver =>
            {
                var windows = driver.FindElementsByName(popupTitle);
                return windows.Count > 0 ? windows[0] : null;
            });

            if (popup == null)
                throw new Exception("Popup window not found!");

            return popup.FindElementByName(elementName);
        }
    }
}
