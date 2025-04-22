Add-Type -AssemblyName PresentationFramework

[xml]$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        Title="RDP Connection Manager" Height="500" Width="750">
    <Grid Margin="10">
        <Grid.RowDefinitions>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="*"/>
            <RowDefinition Height="Auto"/>
        </Grid.RowDefinitions>

        <!-- Form Inputs -->
        <StackPanel Grid.Row="0" Orientation="Horizontal" Margin="0,0,0,10" HorizontalAlignment="Left">
            <StackPanel Margin="5">
                <TextBlock>Machine/IP/FQDN</TextBlock>
                <TextBox Name="MachineInput" Width="150"/>
            </StackPanel>
            <StackPanel Margin="5">
                <TextBlock>Username</TextBlock>
                <TextBox Name="UsernameInput" Width="150"/>
            </StackPanel>
            <StackPanel Margin="5">
                <TextBlock>Password</TextBlock>
                <PasswordBox Name="PasswordInput" Width="150"/>
            </StackPanel>
            <Button Name="AddButton" Content="Add Connection" Margin="10,22,0,0" Width="120"/>
        </StackPanel>

        <!-- Connection Table -->
        <DataGrid Name="ConnGrid" Grid.Row="1" AutoGenerateColumns="False" CanUserAddRows="False" Margin="0,0,0,10">
            <DataGrid.Columns>
                <DataGridTextColumn Header="Machine" Binding="{Binding Machine}" Width="2*"/>
                <DataGridTextColumn Header="Username" Binding="{Binding Username}" Width="2*"/>
                <DataGridTemplateColumn Header="Actions" Width="2*">
                    <DataGridTemplateColumn.CellTemplate>
                        <DataTemplate>
                            <StackPanel Orientation="Horizontal">
                                <Button Content="Connect" Tag="{Binding}" Width="60" Margin="2"/>
                                <Button Content="Remove" Tag="{Binding}" Width="60" Margin="2"/>
                            </StackPanel>
                        </DataTemplate>
                    </DataGridTemplateColumn.CellTemplate>
                </DataGridTemplateColumn>
            </DataGrid.Columns>
        </DataGrid>

        <!-- Save/Load Buttons -->
        <StackPanel Orientation="Horizontal" Grid.Row="2" HorizontalAlignment="Right">
            <Button Name="SaveButton" Content="Save List" Margin="5" Width="100"/>
            <Button Name="LoadButton" Content="Load List" Margin="5" Width="100"/>
        </StackPanel>
    </Grid>
</Window>
"@

# Load WPF
$reader = (New-Object System.Xml.XmlNodeReader $xaml)
$window = [Windows.Markup.XamlReader]::Load($reader)

Add-Type -AssemblyName System.Windows.Forms

# Access UI elements
$machineInput = $window.FindName("MachineInput")
$usernameInput = $window.FindName("UsernameInput")
$passwordInput = $window.FindName("PasswordInput")
$addButton = $window.FindName("AddButton")
$connGrid = $window.FindName("ConnGrid")
$saveButton = $window.FindName("SaveButton")
$loadButton = $window.FindName("LoadButton")

# Data collection
$connections = New-Object System.Collections.ObjectModel.ObservableCollection[Object]
$connGrid.ItemsSource = $connections

# Add connection
$addButton.Add_Click({
    $machine = $machineInput.Text.Trim()
    $username = $usernameInput.Text.Trim()
    $password = $passwordInput.Password

    if (-not $machine -or -not $username -or -not $password) {
        [System.Windows.MessageBox]::Show("All fields are required.")
        return
    }

    $connections.Add([PSCustomObject]@{
        Machine  = $machine
        Username = $username
        Password = $password
    })

    $machineInput.Text = ""
    $usernameInput.Text = ""
    $passwordInput.Password = ""
})

# Handle button clicks inside DataGrid
$connGrid.AddHandler([System.Windows.Controls.Primitives.ButtonBase]::ClickEvent,
    [System.Windows.RoutedEventHandler]{
        $source = $_.OriginalSource
        if ($source -is [System.Windows.Controls.Button] -and $source.Tag) {
            $row = $source.Tag
            if ($source.Content -eq "Connect") {
                cmdkey /generic:"$($row.Machine)" /user:$($row.Username) /pass:$($row.Password) | Out-Null
                Start-Process "mstsc.exe" -ArgumentList "/v:$($row.Machine)"
            } elseif ($source.Content -eq "Remove") {
                $connections.Remove($row)
            }
        }
    })

# Save to JSON
$saveButton.Add_Click({
    $dlg = New-Object System.Windows.Forms.SaveFileDialog
    $dlg.Filter = "JSON Files|*.json"
    if ($dlg.ShowDialog() -eq "OK") {
        $connections | ConvertTo-Json -Depth 3 | Set-Content -Path $dlg.FileName
    }
})

# Load from JSON
$loadButton.Add_Click({
    $dlg = New-Object System.Windows.Forms.OpenFileDialog
    $dlg.Filter = "JSON Files|*.json"
    if ($dlg.ShowDialog() -eq "OK") {
        $connections.Clear()
        $loaded = Get-Content $dlg.FileName | ConvertFrom-Json
        foreach ($item in $loaded) {
            $connections.Add([PSCustomObject]@{
                Machine  = $item.Machine
                Username = $item.Username
                Password = $item.Password
            })
        }
    }
})

# Run the GUI
$window.ShowDialog() | Out-Null
