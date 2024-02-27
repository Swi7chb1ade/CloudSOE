# Cloud OSD ZTI Script
# Written by LZV

# Variables
$osVersion = "Windows 11"
$osBuild = "23H2"
$osLanguage = "en-us"
$osEdition = "Enterprise"
$osActivation = "Volume"

Write-Host -ForegroundColor Green "Starting ABL OSDCloud Zero Touch Install"
Start-Sleep -Seconds 5

Write-Host -ForegroundColor Red "If you booted using Ventoy, remove the USB From the computer or things will break - otherwise leave it connected."
Write-Host -ForegroundColor Red "Continuing after this point is destructive and automatic - press ENTER if you are sure you want to wipe the SSD and install Windows on  this computer"
pause

Start-OSDCloud -OSVersion $osVersion -OSBuild $osBuild -OSLanguage $osLanguage -OSEdition $osEdition -OSActivation $osActivation -Firmware -Restart -ZTI
