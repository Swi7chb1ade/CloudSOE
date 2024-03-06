# Cloud OSD ZTI Script
# Written by LZV

# Paramaters for Start-OSDCloud Command
$osVersion = "Windows 11"
$osBuild = "23H2"
$osLanguage = "en-us"
$osEdition = "Enterprise"
$osActivation = "Volume"

# Unattend location
$unattendUrl = "https://raw.githubusercontent.com/Swi7chb1ade/cloudosd/main/unattend.xml"

# Start Message
Write-Host -ForegroundColor Green "Starting ABL OSDCloud Zero Touch Install"
Start-Sleep -Seconds 5

# Warning Message and confirmation
$warningShell = New-Object -ComObject Wscript.Shell
$userResponse = $warningShell.Popup("If you booted using Ventory, remove the USB from the computer NOW or things will break. `n`nContinuing after this point is DESTRUCTIVE and AUTOMATIC `n`nThe SSD will be automatically wiped and Windows installed `n`nClick OK to continue or CANCEL to abort",0,"WARNING",16+1)

# If user clicks OK, begin process
if($userResponse -eq 1){

# Start OSDCloud Installation
Start-OSDCloud -OSVersion $osVersion -OSBuild $osBuild -OSLanguage $osLanguage -OSEdition $osEdition -OSActivation $osActivation -ZTI

# Copy Unattend File
Invoke-WebRequest $unattendUrl -outFile "C:\Windows\Panther\unattend.xml"

# Restart the computer once completed 
Restart-Computer -Force
}

# If user clicks CANCEL, stop process
else {
    exit 1
}
