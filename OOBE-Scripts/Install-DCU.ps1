<#
.SYNOPSIS
    Script to install Dell Command Update
.FUNCTIONALITY
    Downloads a copy of Dell Command Update from ablcloudstorage\ablcloudsoe and installs on the local machine
.NOTES
    Author: LZV
    Last Edit: 2024-05-01
    Version 1.0
#>

# Script Variables
$dcuUrl = "https://ablcloudsoe.blob.core.windows.net/`$web/Resources/DCU_Install.EXE"
$osdcloudTempFolderPath = "$env:SystemDrive\OSDCloud\Temp"

# Download
Write-Host -ForegroundColor Green "Downloading Dell Command | Update...."
Invoke-WebRequest $dcuUrl -outFile "$osdcloudTempFolderPath\DCU_Install.exe"
Write-Host -ForegroundColor Green "Download completed!"

# Install
Write-Host -ForegroundColor Green "Installing Dell Command | Update, please wait..."
Start-Process -FilePath "$osdcloudTempFolderPath\DCU_Install.exe" -ArgumentList "/s" -Wait
Write-Host -ForegroundColor Green "Install completed!"