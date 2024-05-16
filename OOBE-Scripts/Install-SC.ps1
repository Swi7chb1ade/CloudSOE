<#
.SYNOPSIS
    Script to install the ScreenConnect Client
.FUNCTIONALITY
    Downloads a copy of ScreenConnect from ablcloudstorage\ablcloudsoe and installs on the local machine
.NOTES
    Author: LZV
    Last Edit: 2024-05-01
    Version 1.0
#>

# Set Global Variables
$screenconnectUrl = "https://ablcloudsoe.blob.core.windows.net/`$web/Resources/ScreenConnect.msi"
$osdcloudTempFolderPath = "$env:SystemDrive\OSDCloud\Temp"

# Download
Write-Host -ForegroundColor Green "Downloading ScreenConnect...."
Invoke-WebRequest $screenconnectUrl -outFile "$osdcloudTempFolderPath\ScreenConnect.msi"
Write-Host -ForegroundColor Green "Download completed!"

# Install
Write-Host -ForegroundColor Green "Installing ScreenConnect, please wait..."
Start-Process msiexec -ArgumentList "/i $osdcloudTempFolderPath\ScreenConnect.msi /qn /norestart" -Wait
Write-Host -ForegroundColor Green "Install completed!"