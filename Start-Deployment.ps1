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

Write-Host -ForegroundColor Red "If you booted using Ventoy, remove the USB From the computer or things will break - otherwise leave it connected. When ready to continue press ENTER"
pause

Start-OSDCloud -OSVersion $osVersion -OSBuild $osBuild -OSLanguage $osLanguage -OSEdition $osEdition -OSActivation $osActivation -Firmware -Restart
