<#
.SYNOPSIS
    Script for use with OSDCloud to deploy Windows 11 Enterprise. 
    This script will automatically wipe the device, install Windows 11 Enterprise and copy an unattend.xml file once the install has completed.
    The unattend.xml file will entierly skip the OOBE process, so the end user only has to confirm to the warning relating to data destruction and enter the ABL Asset Number
.FUNCTIONALITY
    OSDCloud Kick off script and finishing touches 
.NOTES
    Author: LZV
    Last Edit: 2024-05-01
    Version 0.1 - Creation (Alpha)
    Version 0.2 - Updated to point to ablcloudsoe Azure storage, commented out SetupComplete.cmd for now
    Version 0.3 - Updated various parts of script, added validation to computer hostname
    Version 1.0 - Updated to use the SetupComplete.cmd file to automatically install core apps to help speed up this process. Out of Alpha, validated working
#>

# Paramaters for Start-OSDCloud Command
$osVersion = "Windows 11"
$osBuild = "23H2"
$osLanguage = "en-us"
$osEdition = "Enterprise"
$osActivation = "Volume"

# Set Global variables here
$unattendUrl = "https://ablcloudsoe.blob.core.windows.net/`$web/Resources/unattend.xml"
$setupCompleteUrl = "https://ablcloudsoe.blob.core.windows.net/`$web/OOBE-Scripts/SetupComplete.cmd"
$unattendFile = "C:\Windows\Panther\unattend.xml"

# Start Message
Write-Host -ForegroundColor Green "Starting ABL OSD Cloud, please wait..."
Start-Sleep -Seconds 5

# Determine if Desktop or Notebook and generate asset name prefix
$hardwareType = (Get-Computerinfo).CsPCSystemType
if($hardwareType -eq "Desktop"){
    $prefix = "PC"
}

elseif($hardwareType -eq "Mobile"){
    $prefix = "NB"
}

# Warning Message and confirmation
$warningShell = New-Object -ComObject Wscript.Shell
$continuePrompt = $warningShell.Popup("If you booted using Ventory, remove the USB from the computer NOW or things will break. `n`nContinuing after this point is DESTRUCTIVE and AUTOMATIC `n`nThe SSD will be automatically wiped and Windows installed `n`nClick OK to continue or CANCEL to abort",0,"WARNING",16+1)

# If user clicks OK, begin process
if($continuePrompt -eq 1){
    
    # Prompt for Asset Tag Number, with some validation included - only accepts a 4 digit number as this is the standard
    while($assetNumber -notmatch '[0-9][0-9][0-9][0-9]'){
        Add-Type -AssemblyName Microsoft.VisualBasic
        $title = "Computer Name"
        $message   = "Enter the 4 digit computer asset number - do not prefix with PC or NB"
        $assetNumber = [Microsoft.VisualBasic.Interaction]::InputBox($message, $title)
    }

    # Create Asset Name variable
    $assetName = $prefix + $assetNumber
    Write-Host -ForegroundColor Green "Starting OSDCloud deployment for $assetName"

    # Start OSDCloud Installation
    Start-OSDCloud -OSVersion $osVersion -OSBuild $osBuild -OSLanguage $osLanguage -OSEdition $osEdition -OSActivation $osActivation -ZTI

    # Copy Unattend File
    Write-Host -ForegroundColor Green "Copying unattend.xml file from Azure Storage"
    Invoke-WebRequest $unattendUrl -outFile $unattendFile

    # Copy SetupComplete.cmd file (Commented out until further notice)
    Write-Host -ForegroundColor Green "Copying setupcomplete.cmd script from Azure Storage"
    Invoke-WebRequest $setupCompleteUrl -outFile "C:\Windows\Setup\Scripts\SetupComplete.cmd"

    # Create text file containing asset number
    Write-Host -ForegroundColor Green "Creating AssetName.txt file with $assetName as contents"
    $assetName | Out-File "C:\OSDCloud\AssetName.txt"

    # Edit the copied unattend.xml file to include the hostname
    Write-Host -ForegroundColor Green "Modifying unattend.xml file to include hostname"
    $unattendXml = [xml](Get-Content $unattendFile)
    $unattendXml.unattend.settings[1].component[1].ComputerName = $assetName
    $unattendXml.save("$unattendFile")

    # Sleep for 30 secnods
    Write-Host -ForegroundColor Green "OSDCloud deployment for $assetName done - Rebooting in 30 seconds"
    Start-Sleep -Seconds 30

    # Restart the computer once completed 
    Restart-Computer -Force
}

# If user clicks CANCEL, stop process
else {
    Write-Host -ForegroundColor Red "Aborting OSDCloud Deployment!!!!"
    Write-Host -ForegroundColor Red "To retry, initiate 'startnet.cmd' from the WindowsPE Command Prompt"
    exit 1
}