<#
.SYNOPSIS
    Moves files from the Desktop to specified locations based on configurations stored in txt files with the help of an UI interface.

.DESCRIPTION
    This script provides a UI interface for configuring the extensions and paths of the files to be moved from the Desktop. The "Save" button saves the configuration in txt files to be used later, while the "Run" button executes the "Run Clean Desktop.ps1" script, which moves the files according to the saved configurations. 

.EXAMPLE
    Run the script:
    - By double-clicking on "Start_Clean Desktop.bat".
    - By right-clicking on "Configuration.ps1" and selecting "Run with PowerShell".
    
.NOTES
    Author: Camelia Bobaru
    Date: 19.02.2023
#>

<#
-> Reading the User Interface
#>
Add-Type -AssemblyName PresentationFramework
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") 

$scriptLocationOnThisPC = split-path -parent $MyInvocation.MyCommand.Definition
$configFilesLocationOnThisPC = "$scriptLocationOnThisPC\Config files"
[xml]$xaml = @"
<Window
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        Title="Configuration setup" Height="496" Width="666" Background="#FF89FFFF" WindowStyle="ToolWindow" ResizeMode="NoResize">
    <Grid>
        <Grid.RowDefinitions>
            <RowDefinition/>
        </Grid.RowDefinitions>
        <Grid.ColumnDefinitions>
            <ColumnDefinition/>
        </Grid.ColumnDefinitions>
        <TabControl Name="TabControl" Background="White" Margin="0,0,0,-39">
            <TabItem Name="tab" Header="Main Configuration" FontFamily="Baskerville Old Face" BorderBrush="#FF00CDD7" Foreground="#FF007ACC" Margin="-2,0,-2,0" FontSize="16">
                <TabItem.Background>
                    <SolidColorBrush Color="#FFD0FFFF" Opacity="0.6"/>
                </TabItem.Background>
                <Grid Cursor="Arrow" Height="350">
                    <Grid.OpacityMask>
                        <LinearGradientBrush EndPoint="0.5,1" StartPoint="0.5,0">
                            <GradientStop Color="Black"/>
                            <GradientStop Color="#FFB66565" Offset="1"/>
                        </LinearGradientBrush>
                    </Grid.OpacityMask>
                    <Grid.Background>
                        <ImageBrush ImageSource="$configFilesLocationOnThisPC\background.png" Stretch="Fill"/>
                    </Grid.Background>
                    <Grid.ColumnDefinitions>
                        <ColumnDefinition/>
                    </Grid.ColumnDefinitions>
                    <TextBox Name="TBDestinationPath" HorizontalAlignment="Left" Margin="51,61,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="542" Height="22" AutomationProperties.HelpText="Introduce here the folder path where you want to move the icons from your Desktop." AutomationProperties.IsOffscreenBehavior="Onscreen" SelectionBrush="#FF00CDD7">
                        <TextBox.BorderBrush>
                            <SolidColorBrush Color="#FFABADB3" Opacity="0"/>
                        </TextBox.BorderBrush>
                        <TextBox.SelectionTextBrush>
                            <SolidColorBrush Color="White" Opacity="0.7"/>
                        </TextBox.SelectionTextBrush>
                        <TextBox.Background>
                            <SolidColorBrush Color="White" Opacity="0.7"/>
                        </TextBox.Background>
                    </TextBox>
                    <Button Name="browse" Cursor="Hand" Content="..." HorizontalAlignment="Left" Height="22" Margin="597,61,0,0" VerticalAlignment="Top" Width="35" BorderBrush="#FFF7F7F7" Background="White"/>
                    <Label Content="Destination path for Desktop icons" HorizontalAlignment="Left" Margin="51,32,0,0" VerticalAlignment="Top" FontSize="16" FontWeight="Bold" Height="28" Width="242"/>
                    <TextBox Name="TBAllowedExtensions" HorizontalAlignment="Left" Margin="51,149,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="542" Height="123" SelectionBrush="#FF00CDD7">
                        <TextBox.BorderBrush>
                            <SolidColorBrush Color="#FFABADB3" Opacity="0"/>
                        </TextBox.BorderBrush>
                        <TextBox.Background>
                            <SolidColorBrush Color="White" Opacity="0.7"/>
                        </TextBox.Background>
                    </TextBox>
                    <Label Content="Allowed file extensions on Desktop" HorizontalAlignment="Left" Margin="51,118,0,0" VerticalAlignment="Top" Width="542" FontSize="16" FontWeight="Bold" Height="28"/>
                    
                </Grid>
            </TabItem>
            <TabItem Name="tab1" Header="Additional Configurations 1" FontFamily="Baskerville Old Face" BorderBrush="#FF00CDD7" Foreground="#FF007ACC" Margin="-2,0,-2,0" FontSize="16">
                <TabItem.Background>
                    <LinearGradientBrush EndPoint="0,1" Opacity="0.6">
                        <GradientStop Color="#FFF0F0F0"/>
                        <GradientStop Color="#FFE5F9E6" Offset="1"/>
                    </LinearGradientBrush>
                </TabItem.Background>
                <Grid Height="350">
                    <Grid.ColumnDefinitions>
                        <ColumnDefinition/>
                    </Grid.ColumnDefinitions>
                    <Grid.Background>
                        <ImageBrush ImageSource="$configFilesLocationOnThisPC\background2.png"/>
                    </Grid.Background>
                    <TextBox Name="TBAddDetinationPath1" HorizontalAlignment="Left" Margin="50,61,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="542" Height="22" AutomationProperties.HelpText="Introduce here the folder path where you want to move the icons from your Desktop." AutomationProperties.IsOffscreenBehavior="Onscreen" SelectionBrush="#FF00CDD7">
                        <TextBox.Background>
                            <SolidColorBrush Color="White" Opacity="0.7"/>
                        </TextBox.Background>
                        <TextBox.BorderBrush>
                            <SolidColorBrush Color="#FFABADB3" Opacity="0"/>
                        </TextBox.BorderBrush>
                    </TextBox>
                    <Button Name="browse1" Cursor="Hand" Content="..." HorizontalAlignment="Left" Height="22" Margin="597,61,0,0" VerticalAlignment="Top" Width="35" BorderBrush="#FFF7F7F7" Background="White"/>
                    <Label Content="Additional destination path" HorizontalAlignment="Left" Margin="50,32,0,0" VerticalAlignment="Top" FontSize="16" FontWeight="Bold"/>
                    <TextBox Name="TBAddExtensions1" HorizontalAlignment="Left" Margin="50,149,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="542" Height="123" SelectionBrush="#FF00CDD7">
                        <TextBox.BorderBrush>
                            <SolidColorBrush Color="#FFABADB3" Opacity="0"/>
                        </TextBox.BorderBrush>
                        <TextBox.Background>
                            <SolidColorBrush Color="White" Opacity="0.7"/>
                        </TextBox.Background>
                    </TextBox>
                    <Label Content="Extensions of files that should be moved to this path" HorizontalAlignment="Left" Margin="50,118,0,0" VerticalAlignment="Top" Width="542" FontSize="16" FontWeight="Bold"/>
                    
                </Grid>
            </TabItem>
            <TabItem Name="tab2" Header="Additional Configurations 2" FontFamily="Baskerville Old Face" BorderBrush="#FF00CDD7" Foreground="#FF007ACC" Margin="-2,0,-2,0" FontSize="16">
                <TabItem.Background>
                    <LinearGradientBrush EndPoint="0,1" Opacity="0.6">
                        <GradientStop Color="#FFF0F0F0"/>
                        <GradientStop Color="#FFE5F9E6" Offset="1"/>
                    </LinearGradientBrush>
                </TabItem.Background>
                <Grid Height="350">
                    <Grid.ColumnDefinitions>
                        <ColumnDefinition/>
                    </Grid.ColumnDefinitions>
                    <Grid.Background>
                        <ImageBrush ImageSource="$configFilesLocationOnThisPC\background2.png"/>
                    </Grid.Background>
                    <TextBox Name="TBAddDetinationPath2" HorizontalAlignment="Left" Margin="50,61,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="542" Height="22" AutomationProperties.HelpText="Introduce here the folder path where you want to move the icons from your Desktop." AutomationProperties.IsOffscreenBehavior="Onscreen" SelectionBrush="#FF00CDD7">
                        <TextBox.BorderBrush>
                            <SolidColorBrush Color="#FFABADB3" Opacity="0"/>
                        </TextBox.BorderBrush>
                        <TextBox.Background>
                            <SolidColorBrush Color="White" Opacity="0.7"/>
                        </TextBox.Background>
                    </TextBox>
                    <Button Name="browse2" Cursor="Hand" Content="..." HorizontalAlignment="Left" Height="22" Margin="597,61,0,0" VerticalAlignment="Top" Width="35" BorderBrush="#FFF7F7F7" Background="White"/>
                    <Label Content="Additional destination path" HorizontalAlignment="Left" Margin="50,32,0,0" VerticalAlignment="Top" FontSize="16" FontWeight="Bold"/>
                    <TextBox Name="TBAddExtensions2" HorizontalAlignment="Left" Margin="50,149,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="542" Height="123" SelectionBrush="#FF00CDD7">
                        <TextBox.BorderBrush>
                            <SolidColorBrush Color="#FFABADB3" Opacity="0"/>
                        </TextBox.BorderBrush>
                        <TextBox.Background>
                            <SolidColorBrush Color="White" Opacity="0.7"/>
                        </TextBox.Background>
                    </TextBox>
                    <Label Content="Extensions of files that should be moved to this path" HorizontalAlignment="Left" Margin="50,118,0,0" VerticalAlignment="Top" Width="542" FontSize="16" FontWeight="Bold"/>
                  
                </Grid>
            </TabItem>
            <TabItem Name="tab3" Header="Additional Configurations 3" FontFamily="Baskerville Old Face" BorderBrush="#FF00CDD7" Foreground="#FF007ACC" Margin="-2,0,-2,0" HorizontalAlignment="Stretch" FontSize="16">
                <TabItem.Background>
                    <LinearGradientBrush EndPoint="0,1" Opacity="0.6">
                        <GradientStop Color="#FFF0F0F0"/>
                        <GradientStop Color="#FFE5F9E6" Offset="1"/>
                    </LinearGradientBrush>
                </TabItem.Background>
                <Grid Height="350">
                    <Grid.ColumnDefinitions>
                        <ColumnDefinition/>
                    </Grid.ColumnDefinitions>
                    <Grid.Background>
                        <ImageBrush ImageSource="$configFilesLocationOnThisPC\background2.png"/>
                    </Grid.Background>
                    <TextBox Name="TBAddDetinationPath3" HorizontalAlignment="Left" Margin="50,61,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="542" Height="22" AutomationProperties.HelpText="Introduce here the folder path where you want to move the icons from your Desktop." AutomationProperties.IsOffscreenBehavior="Onscreen" SelectionBrush="#FF00CDD7">
                        <TextBox.BorderBrush>
                            <SolidColorBrush Color="#FFABADB3" Opacity="0"/>
                        </TextBox.BorderBrush>
                        <TextBox.Background>
                            <SolidColorBrush Color="White" Opacity="0.7"/>
                        </TextBox.Background>
                    </TextBox>
                    <Button Name="browse3" Cursor="Hand" Content="..." HorizontalAlignment="Left" Height="22" Margin="597,61,0,0" VerticalAlignment="Top" Width="35" BorderBrush="#FFF7F7F7" Background="White"/>
                    <Label Content="Additional destination path" HorizontalAlignment="Left" Margin="50,32,0,0" VerticalAlignment="Top" FontSize="16" FontWeight="Bold"/>
                    <TextBox Name="TBAddExtensions3" HorizontalAlignment="Left" Margin="50,149,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="542" Height="123" SelectionBrush="#FF00CDD7">
                        <TextBox.BorderBrush>
                            <SolidColorBrush Color="#FFABADB3" Opacity="0"/>
                        </TextBox.BorderBrush>
                        <TextBox.Background>
                            <SolidColorBrush Color="White" Opacity="0.7"/>
                        </TextBox.Background>
                    </TextBox>
                    <Label Content="Extensions of files that should be moved to this path" HorizontalAlignment="Left" Margin="50,118,0,0" VerticalAlignment="Top" Width="542" FontSize="16" FontWeight="Bold"/>
                    
                </Grid>
            </TabItem>
            <TabItem Name="tab4" Header="Additional Configurations 4" FontFamily="Baskerville Old Face" BorderBrush="#FF00CDD7" Foreground="#FF007ACC" HorizontalAlignment="Stretch" Margin="-2,0,-2,0" FontSize="16">
                <TabItem.Background>
                    <LinearGradientBrush EndPoint="0,1" Opacity="0.6">
                        <GradientStop Color="#FFF0F0F0"/>
                        <GradientStop Color="#FFE5F9E6" Offset="1"/>
                    </LinearGradientBrush>
                </TabItem.Background>
                <Grid Height="350">
                    <Grid.ColumnDefinitions>
                        <ColumnDefinition/>  
                    </Grid.ColumnDefinitions>
                    <Grid.Background>
                        <ImageBrush ImageSource="$configFilesLocationOnThisPC\background2.png"/>
                    </Grid.Background>
                    <TextBox Name="TBAddDetinationPath4" HorizontalAlignment="Left" Margin="50,61,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="542" Height="22" AutomationProperties.HelpText="Introduce here the folder path where you want to move the icons from your Desktop." AutomationProperties.IsOffscreenBehavior="Onscreen" SelectionBrush="#FF00CDD7">
                        <TextBox.BorderBrush>
                            <SolidColorBrush Color="#FFABADB3" Opacity="0"/>
                        </TextBox.BorderBrush>
                        <TextBox.Background>
                            <SolidColorBrush Color="White" Opacity="0.7"/>
                        </TextBox.Background>
                    </TextBox>
                    <Button Name="browse4" Cursor="Hand" Content="..." HorizontalAlignment="Left" Height="22" Margin="597,61,0,0" VerticalAlignment="Top" Width="35" BorderBrush="#FFF7F7F7" Background="White"/>
                    <Label Content="Additional destination path" HorizontalAlignment="Left" Margin="50,32,0,0" VerticalAlignment="Top" FontSize="16" FontWeight="Bold"/>
                    <TextBox Name="TBAddExtensions4" HorizontalAlignment="Left" Margin="50,149,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="542" Height="123" SelectionBrush="#FF00CDD7">
                        <TextBox.BorderBrush>
                            <SolidColorBrush Color="#FFABADB3" Opacity="0"/>
                        </TextBox.BorderBrush>
                        <TextBox.Background>
                            <SolidColorBrush Color="White" Opacity="0.7"/>
                        </TextBox.Background>
                    </TextBox>
                    <Label Content="Extensions of files that should be moved to this path" HorizontalAlignment="Left" Margin="50,118,0,0" VerticalAlignment="Top" Width="542" FontSize="16" FontWeight="Bold"/>
                    
                </Grid>
            </TabItem>
            <TabItem Name="tab5" Header="Additional Configurations 5" FontFamily="Baskerville Old Face" BorderBrush="#FF00CDD7" Foreground="#FF007ACC" Margin="-2,0,-2,0" FontSize="16">
                <TabItem.Background>
                    <LinearGradientBrush EndPoint="0,1" Opacity="0.6">
                        <GradientStop Color="#FFF0F0F0"/>
                        <GradientStop Color="#FFE5F9E6" Offset="1"/>
                    </LinearGradientBrush>
                </TabItem.Background>
                <Grid Height="350">
                    <Grid.ColumnDefinitions>
                        <ColumnDefinition/>
                    </Grid.ColumnDefinitions>
                    <Grid.Background>
                        <ImageBrush ImageSource="$configFilesLocationOnThisPC\background2.png"/>
                    </Grid.Background>
                    <TextBox Name="TBAddDetinationPath5" HorizontalAlignment="Left" Margin="50,61,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="542" Height="22" AutomationProperties.HelpText="Introduce here the folder path where you want to move the icons from your Desktop." AutomationProperties.IsOffscreenBehavior="Onscreen" SelectionBrush="#FF00CDD7">
                        <TextBox.BorderBrush>
                            <SolidColorBrush Color="#FFABADB3" Opacity="0"/>
                        </TextBox.BorderBrush>
                        <TextBox.Background>
                            <SolidColorBrush Color="White" Opacity="0.7"/>
                        </TextBox.Background>
                    </TextBox>
                    <Button Name="browse5" Cursor="Hand" Content="..." HorizontalAlignment="Left" Height="22" Margin="597,61,0,0" VerticalAlignment="Top" Width="35" BorderBrush="#FFF7F7F7" Background="White"/>
                    <Label Content="Additional destination path" HorizontalAlignment="Left" Margin="50,32,0,0" VerticalAlignment="Top" FontSize="16" FontWeight="Bold"/>
                    <TextBox Name="TBAddExtensions5" HorizontalAlignment="Left" Margin="50,149,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="542" Height="123" SelectionBrush="#FF00CDD7">
                        <TextBox.BorderBrush>
                            <SolidColorBrush Color="#FFABADB3" Opacity="0"/>
                        </TextBox.BorderBrush>
                        <TextBox.Background>
                            <SolidColorBrush Color="White" Opacity="0.7"/>
                        </TextBox.Background>
                    </TextBox>
                    <Label Content="Extensions of files that should be moved to this path" HorizontalAlignment="Left" Margin="50,118,0,0" VerticalAlignment="Top" Width="542" FontSize="16" FontWeight="Bold"/>
                    
                    
                </Grid>
            </TabItem>
        </TabControl>
        <Image HorizontalAlignment="Left" Height="97" Margin="2,50,0,0" VerticalAlignment="Top" Width="70" Source="$configFilesLocationOnThisPC\Logo 2.jpeg"/>
        <Button Name="SaveBtn" Content="Save" HorizontalAlignment="Left" Margin="51,385,0,0" VerticalAlignment="Top" Width="107" RenderTransformOrigin="0.902,0.069" Height="39" FontSize="22" FontWeight="Bold" BorderThickness="0,0,0,0" BorderBrush="#FFA43D3D" Cursor="Hand">
                        <Button.OpacityMask>
                            <LinearGradientBrush EndPoint="0.5,1" StartPoint="0.5,0">
                                <GradientStop Color="Black"/>
                                <GradientStop Color="#FF9C4141" Offset="1"/>
                            </LinearGradientBrush>
                        </Button.OpacityMask>
                        <Button.RenderTransform>
                            <TransformGroup>
                                <ScaleTransform/>
                                <SkewTransform/>
                                <RotateTransform Angle="-0.142"/>
                                <TranslateTransform X="-0.042" Y="-0.106"/>
                            </TransformGroup>
                        </Button.RenderTransform>

                        <Button.Style>
                            <Style TargetType="{x:Type Button}">
                                <Setter Property="Background" >
                                    <Setter.Value>
                                        <ImageBrush ImageSource="$configFilesLocationOnThisPC\CleanDesktopBtn.png"></ImageBrush>
                                    </Setter.Value>
                                </Setter>
                                <Setter Property="Template">
                                    <Setter.Value>
                                        <ControlTemplate TargetType="{x:Type Button}">
                                            <Border Background="{TemplateBinding Background}">
                                                <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                                            </Border>
                                        </ControlTemplate>
                                    </Setter.Value>
                                </Setter>
                                <Style.Triggers>
                                    <Trigger Property="IsMouseOver" Value="True">
                                        <Setter Property="Background" >
                                            <Setter.Value>
                                                <ImageBrush ImageSource="$configFilesLocationOnThisPC\CleanDesktopBtn_hover.png"></ImageBrush>
                                            </Setter.Value>
                                        </Setter>
                                    </Trigger>
                                    <Trigger Property="IsEnabled" Value="False">
                                        <Setter Property="Background" >
                                            <Setter.Value>
                                                <ImageBrush ImageSource="$configFilesLocationOnThisPC\CleanDesktopBtn_inactive.png"></ImageBrush>
                                            </Setter.Value>
                                        </Setter>
                                    </Trigger>
                                </Style.Triggers>
                            </Style>
                        </Button.Style>
                    </Button>
                    <Button Name="RunBtn" Content="Run" HorizontalAlignment="Left" Margin="198,385,0,0" VerticalAlignment="Top" Width="107" RenderTransformOrigin="0.902,0.069" Height="39" FontSize="22" FontWeight="Bold" BorderThickness="0,0,0,0" BorderBrush="#FFA43D3D" Cursor="Hand">
                        <Button.Style>
                            <Style TargetType="{x:Type Button}">
                                <Setter Property="Background" >
                                    <Setter.Value>
                                        <ImageBrush ImageSource="$configFilesLocationOnThisPC\CleanDesktopBtn.png"></ImageBrush>
                                    </Setter.Value>
                                </Setter>
                                <Setter Property="Template">
                                    <Setter.Value>
                                        <ControlTemplate TargetType="{x:Type Button}">
                                            <Border Background="{TemplateBinding Background}">
                                                <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                                            </Border>
                                        </ControlTemplate>
                                    </Setter.Value>
                                </Setter>
                                <Style.Triggers>
                                    <Trigger Property="IsMouseOver" Value="True">
                                        <Setter Property="Background" >
                                            <Setter.Value>
                                                <ImageBrush ImageSource="$configFilesLocationOnThisPC\CleanDesktopBtn_hover.png"></ImageBrush>
                                            </Setter.Value>
                                        </Setter>
                                    </Trigger>
                                    <Trigger Property="IsEnabled" Value="False">
                                        <Setter Property="Background" >
                                            <Setter.Value>
                                                <ImageBrush ImageSource="$configFilesLocationOnThisPC\CleanDesktopBtn_inactive.png"></ImageBrush>
                                            </Setter.Value>
                                        </Setter>
                                    </Trigger>
                                </Style.Triggers>
                            </Style>
                        </Button.Style>
                        <Button.OpacityMask>
                            <LinearGradientBrush EndPoint="0.5,1" StartPoint="0.5,0">
                                <GradientStop Color="Black"/>
                                <GradientStop Color="#FF9C4141" Offset="1"/>
                            </LinearGradientBrush>
                        </Button.OpacityMask>
                        <Button.RenderTransform>
                            <TransformGroup>
                                <ScaleTransform/>
                                <SkewTransform/>
                                <RotateTransform Angle="-0.142"/>
                                <TranslateTransform X="-0.042" Y="-0.106"/>
                            </TransformGroup>
                        </Button.RenderTransform>
                    </Button>

        <TextBlock Name="ErrorTB" HorizontalAlignment="Left" Margin="350,385,0,0" VerticalAlignment="Top" Width="215" Height="89" Foreground="Red" TextWrapping="Wrap"/>
    </Grid>
</Window>

"@
$reader = (New-Object System.Xml.XmlNodeReader $xaml)
try{$Form=[Windows.Markup.XamlReader]::Load( $reader )}
catch{Write-Host "Unable to load Windows.Markup.XamlReader"; exit}
 
# Store Form Objects In PowerShell
$xaml.SelectNodes("//*[@Name]") | ForEach-Object {Set-Variable -Name ($_.Name) -Value $Form.FindName($_.Name)}


<#
-> Reading the txt files for main configuration
#>
$allowedExtensionsOnDesktopFilePath = "$configFilesLocationOnThisPC\AllowedExtensionsOnDesktop.txt"
$destinationPathOfFilesFilePath = "$configFilesLocationOnThisPC\DestinationPathOfFiles.txt"

$listOfAllowedExtensionsOnDesktop = Get-Content -Path $allowedExtensionsOnDesktopFilePath
$destinationPathOfFiles = Get-Content -Path $destinationPathOfFilesFilePath

$TBDestinationPath.Text = $destinationPathOfFiles
$TBAllowedExtensions.Text = $listOfAllowedExtensionsOnDesktop

<#
-> Reading the txt files for additional configurations
#>
#1
[System.Collections.ArrayList] $contentOfAdditionalFile = Get-Content -Path "$configFilesLocationOnThisPC\Path_AdditionalConfig1.txt"
$destinationPathOfThisFile = $contentOfAdditionalFile[0]
$TBAddDetinationPath1.text = $destinationPathOfThisFile
$contentOfAdditionalFile.Remove($destinationPathOfThisFile)
$TBAddExtensions1.Text = $contentOfAdditionalFile
#2
$contentOfAdditionalFile = Get-Content -Path "$configFilesLocationOnThisPC\Path_AdditionalConfig2.txt"
$destinationPathOfThisFile = $contentOfAdditionalFile[0]
$TBAddDetinationPath2.text = $destinationPathOfThisFile
$contentOfAdditionalFile.Remove($destinationPathOfThisFile)
$TBAddExtensions2.Text = $contentOfAdditionalFile
#3
$contentOfAdditionalFile = Get-Content -Path "$configFilesLocationOnThisPC\Path_AdditionalConfig3.txt"
$destinationPathOfThisFile = $contentOfAdditionalFile[0]
$TBAddDetinationPath3.text = $destinationPathOfThisFile
$contentOfAdditionalFile.Remove($destinationPathOfThisFile)
$TBAddExtensions3.Text = $contentOfAdditionalFile

#4
$contentOfAdditionalFile = Get-Content -Path "$configFilesLocationOnThisPC\Path_AdditionalConfig4.txt"
$destinationPathOfThisFile = $contentOfAdditionalFile[0]
$TBAddDetinationPath4.text = $destinationPathOfThisFile
$contentOfAdditionalFile.Remove($destinationPathOfThisFile)
$TBAddExtensions4.Text = $contentOfAdditionalFile
#5
$contentOfAdditionalFile = Get-Content -Path "$configFilesLocationOnThisPC\Path_AdditionalConfig5.txt"
$destinationPathOfThisFile = $contentOfAdditionalFile[0]
$TBAddDetinationPath5.text = $destinationPathOfThisFile
$contentOfAdditionalFile.Remove($destinationPathOfThisFile)
$TBAddExtensions5.Text = $contentOfAdditionalFile

<#
-> Adding click action to Save button and Run button
#>

function SaveConfig {
    Set-Content -Path $destinationPathOfFilesFilePath -Value $TBDestinationPath.text
    Set-Content -Path $allowedExtensionsOnDesktopFilePath -Value (($TBAllowedExtensions.Text) -replace ' ',"`n")
    Set-Content -Path "$configFilesLocationOnThisPC\Path_AdditionalConfig1.txt" -Value (("$($TBAddDetinationPath1.Text) $($TBAddExtensions1.Text)") -replace ' ',"`n")
    Set-Content -Path "$configFilesLocationOnThisPC\Path_AdditionalConfig2.txt" -Value (("$($TBAddDetinationPath2.Text) $($TBAddExtensions2.Text)") -replace ' ',"`n")
    Set-Content -Path "$configFilesLocationOnThisPC\Path_AdditionalConfig3.txt" -Value (("$($TBAddDetinationPath3.Text) $($TBAddExtensions3.Text)") -replace ' ',"`n")
    Set-Content -Path "$configFilesLocationOnThisPC\Path_AdditionalConfig4.txt" -Value (("$($TBAddDetinationPath4.Text) $($TBAddExtensions4.Text)") -replace ' ',"`n")
    Set-Content -Path "$configFilesLocationOnThisPC\Path_AdditionalConfig5.txt" -Value (("$($TBAddDetinationPath5.Text) $($TBAddExtensions5.Text)") -replace ' ',"`n")
    $wshell = New-Object -ComObject Wscript.Shell

}

function RunCleanDesktop {
    SaveConfig
    $a = new-object -comobject wscript.shell 
    $intAnswer = $a.popup("Successfully saved! Do you want to run the script Run Clean Desktop?", 0,"Run Clean Desktop",4) 
    If ($intAnswer -eq 6) { 
        Powershell.exe -executionpolicy bypass -file "$scriptLocationOnThisPC\Run Clean Desktop.ps1"
    }
}
$SaveBtn.Add_click({
    SaveConfig
    $wshell = new-object -comobject wscript.shell
    $wshell.Popup("Successfully saved!",0,"Change",0x1)
})

$RunBtn.Add_click({
    RunCleanDesktop
})

<#
-> Adding click action to Browse buttons
#>

$browse.Add_click({
    $openFolderDialog = New-Object System.Windows.Forms.FolderBrowserDialog
    $openFolderDialog.ShowDialog() | Out-Null
    $TBDestinationPath.Text =  $openFolderDialog.SelectedPath
})

$browse1.Add_click({
    $openFolderDialog = New-Object System.Windows.Forms.FolderBrowserDialog
    $openFolderDialog.ShowDialog() | Out-Null
    $TBAddDetinationPath1.Text =  $openFolderDialog.SelectedPath
})

$browse2.Add_click({
    $openFolderDialog = New-Object System.Windows.Forms.FolderBrowserDialog
    $openFolderDialog.ShowDialog() | Out-Null
    $TBAddDetinationPath2.Text =  $openFolderDialog.SelectedPath
})

$browse3.Add_click({
    $openFolderDialog = New-Object System.Windows.Forms.FolderBrowserDialog
    $openFolderDialog.ShowDialog() | Out-Null
    $TBAddDetinationPath3.Text =  $openFolderDialog.SelectedPath
})

$browse4.Add_click({
    $openFolderDialog = New-Object System.Windows.Forms.FolderBrowserDialog
    $openFolderDialog.ShowDialog() | Out-Null
    $TBAddDetinationPath4.Text =  $openFolderDialog.SelectedPath
})

$browse5.Add_click({
    $openFolderDialog = New-Object System.Windows.Forms.FolderBrowserDialog
    $openFolderDialog.ShowDialog() | Out-Null
    $TBAddDetinationPath5.Text =  $openFolderDialog.SelectedPath
})
<#
-> Load XAML elements into a hash table to be able to create the timer object
#>
$script:hash = [hashtable]::Synchronized(@{})
$hash.Window = [Windows.Markup.XamlReader]::Load((New-Object -TypeName System.Xml.XmlNodeReader -ArgumentList $xaml))
$xaml.SelectNodes("//*[@*[contains(translate(name(.),'n','N'),'Name')]]") | ForEach-Object -Process {
    $hash.$($_.Name) = $hash.Window.FindName($_.Name)
}
 
<#
-> Create a timer object to check if the buttons should be enabled
#>
$Hash.Stopwatch = New-Object System.Diagnostics.Stopwatch
$Hash.Timer = New-Object System.Windows.Forms.Timer
    $Hash.Timer.Enabled = $true
    $Hash.Timer.Interval = 55
$Hash.Stopwatch.Start()
$Hash.Timer.Add_Tick({
    $ErrorTB.Text = ""
    $SaveBtn.IsEnabled = $true
    $RunBtn.IsEnabled = $true
    $ShowError = $false
    if((($TBAddDetinationPath1.Text).Length -ne 0)){
        if((Test-Path -Path $TBAddDetinationPath1.Text) -eq $false) {
            $ShowError = $true
            $ErrorTB.Text = "In ""Additional Configurations 1"" the path is invalid!"
        } 
    }
    if((($TBAddDetinationPath2.Text).Length -ne 0)){
        if((Test-Path -Path $TBAddDetinationPath2.Text) -eq $false) {
            $ShowError = $true
            $ErrorTB.Text = "In ""Additional Configurations 2"" the path is invalid!"
        } 
    }
    if((($TBAddDetinationPath3.Text).Length -ne 0)){
        if((Test-Path -Path $TBAddDetinationPath3.Text) -eq $false) {
            $ShowError = $true
            $ErrorTB.Text = "In ""Additional Configurations 3"" the path is invalid!"
        } 
    }
    if((($TBAddDetinationPath4.Text).Length -ne 0)){
        if((Test-Path -Path $TBAddDetinationPath4.Text) -eq $false) {
            $ShowError = $true
            $ErrorTB.Text = "In ""Additional Configurations 4"" the path is invalid!"
        } 
    }
    if((($TBAddDetinationPath5.Text).Length -ne 0)){
        if((Test-Path -Path $TBAddDetinationPath5.Text) -eq $false) {
            $ShowError = $true
            $ErrorTB.Text = "In ""Additional Configurations 5"" the path is invalid!"
        } 
    }
    if((($TBAddDetinationPath1.Text).Length -eq 0) -ne
    (($TBAddExtensions1.Text).Length -eq 0)) {
        $ShowError = $true
        $ErrorTB.Text = "In ""Additional Configurations 1"" one field is empty!"        
    }
    if((($TBAddDetinationPath2.Text).Length -eq 0) -ne
    (($TBAddExtensions2.Text).Length -eq 0)) {
        $ShowError = $true
        $ErrorTB.Text = "In ""Additional Configurations 2"" one field is empty!"        
    }
    if((($TBAddDetinationPath3.Text).Length -eq 0) -ne
    (($TBAddExtensions3.Text).Length -eq 0)) {
        $ShowError = $true
        $ErrorTB.Text = "In ""Additional Configurations 3"" one field is empty!"        
    }
    if((($TBAddDetinationPath4.Text).Length -eq 0) -ne
    (($TBAddExtensions4.Text).Length -eq 0)) {
        $ShowError = $true
        $ErrorTB.Text = "In ""Additional Configurations 4"" one field is empty!"        
    }
    if((($TBAddDetinationPath5.Text).Length -eq 0) -ne
    (($TBAddExtensions5.Text).Length -eq 0)) {
        $ShowError = $true
        $ErrorTB.Text = "In ""Additional Configurations 5"" one field is empty!"        
    }
    if((($TBAllowedExtensions.Text).Length -eq 0)){
        $ShowError = $true
        $ErrorTB.Text = """Allowed file extensions on Desktop"" is empty!"
    }
    if((($TbDestinationPath.Text).Length -eq 0)) { 
        $ShowError = $true 
        $ErrorTB.Text = """Destination path for Desktop icons"" is empty!"
    }
    else {
            $path = $TbDestinationPath.Text
            if((Test-Path -Path $path) -eq $false) {
                $ShowError = $true
                $ErrorTB.Text = """Destination path for Desktop icons"" is invalid!"
            } 
           
    } 

    if($ShowError) {
        $SaveBtn.IsEnabled = $false
        $RunBtn.IsEnabled = $false
    }        
})
$Hash.Timer.Start()
$Form.ShowDialog()
