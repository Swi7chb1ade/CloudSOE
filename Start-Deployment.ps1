# Cloud OSD ZTI Script
# Written by LZV

# Paramaters for Start-OSDCloud Command
$osVersion = "Windows 11"
$osBuild = "23H2"
$osLanguage = "en-us"
$osEdition = "Enterprise"
$osActivation = "Volume"

# Start Message
Write-Host -ForegroundColor Green "Starting ABL OSDCloud Zero Touch Install"
Start-Sleep -Seconds 5

# Warning Message
Write-Host -ForegroundColor Red "############################################################################################################################"
Write-Host -ForegroundColor Red "#                                                      WARNING WARNING WARNING                                             #"
Write-Host -ForegroundColor Red "# If you booted using Ventoy, remove the USB From the computer or things will break - otherwise leave it connected.        #"
Write-Host -ForegroundColor Red "# Continuing after this point is destructive and automatic - the SSD will be automatically wiped and Windows installed     #"
Write-Host -ForegroundColor Red "# Press ENTER if you are sure you want to wipe the computer and install Windows                                            #"
Write-Host -ForegroundColor Red "############################################################################################################################"

# Pause to wait for user to confirm 
pause

# SENDIT
Start-OSDCloud -OSVersion $osVersion -OSBuild $osBuild -OSLanguage $osLanguage -OSEdition $osEdition -OSActivation $osActivation -Restart -ZTI
