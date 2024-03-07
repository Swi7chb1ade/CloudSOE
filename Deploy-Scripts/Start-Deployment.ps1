<#
.SYNOPSIS
    Script for use with OSDCloud to deploy Windows 11 Enterprise. 
    This script will automatically wipe the device, install Windows 11 Enterprise and copy an unattend.xml file once the install has completed.
    The unattend.xml file will entierly skip the OOBE process, so the end user only has to confirm to the warning relating to data destruction
.FUNCTIONALITY
    OSDCloud Kick off script and finishing touches 
.NOTES
    Author: LZV
    Last Edit: 2024-03-07
    Version 0.1 - Creation (Alpha)
#>

# Determine if Desktop or Mobile computer
$hardwareType = (Get-Computerinfo).CsPCSystemType
if($hardwareType -eq "Desktop"){
    $prefix = "PC"
}
elseif($hardwareType -eq "Mobile"){
    $prefix = "NB"
}

# Paramaters for Start-OSDCloud Command
$osVersion = "Windows 11"
$osBuild = "23H2"
$osLanguage = "en-us"
$osEdition = "Enterprise"
$osActivation = "Volume"

# Unattend location
$unattendUrl = "https://raw.githubusercontent.com/Swi7chb1ade/CloudSOE/main/Resources/unattend.xml"
$setupCompleteUrl = "https://raw.githubusercontent.com/Swi7chb1ade/CloudSOE/main/OOBE-Scripts/SetupComplete.cmd"

# Start Message
Write-Host -ForegroundColor Green "Starting ABL OSDCloud Zero Touch Install"
Start-Sleep -Seconds 5

# Warning Message and confirmation
$warningShell = New-Object -ComObject Wscript.Shell
$userResponse = $warningShell.Popup("If you booted using Ventory, remove the USB from the computer NOW or things will break. `n`nContinuing after this point is DESTRUCTIVE and AUTOMATIC `n`nThe SSD will be automatically wiped and Windows installed `n`nClick OK to continue or CANCEL to abort",0,"WARNING",16+1)

# If user clicks OK, begin process
if($userResponse -eq 1){
    # Gather asset number
    # Prompt for Asset Tag Number
    Add-Type -AssemblyName Microsoft.VisualBasic
    $title = "Computer Name"
    $message   = 'Enter the computer asset number:'
    $assetNumber = [Microsoft.VisualBasic.Interaction]::InputBox($message, $title)

    # Create Asset Name variable
    $assetName = $prefix + $assetNumber
    Write-Host -ForegroundColor Green "Starting OSDCloud deployment for $assetName"

    # Start OSDCloud Installation
    Start-OSDCloud -OSVersion $osVersion -OSBuild $osBuild -OSLanguage $osLanguage -OSEdition $osEdition -OSActivation $osActivation -ZTI

    # Copy Unattend File    
    Invoke-WebRequest $unattendUrl -outFile "C:\Windows\Panther\unattend.xml"

    # Copy SetupComplete.cmd file
    Invoke-WebRequest $setupCompleteUrl -outFile "C:\Windows\Setup\Scripts\SetupComplete.cmd"

    # Create text file containing asset number
    $assetName | Out-File "C:\OSDCloud\AssetName.txt"

    # Sleep for 30 secnods
    Write-Host -ForegroundColor Green "OSDCloud deployment for $assetName done - Rebooting in 30 seconds"
    Start-Sleep -Seconds 30

    # Restart the computer once completed 
    Restart-Computer -Force
}

# If user clicks CANCEL, stop process
else {
    Write-Host -ForegroundColor Red "Aborting OSDCloud Deployment!!!!"
    exit 1
}
