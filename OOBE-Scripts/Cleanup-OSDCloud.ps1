<#
.SYNOPSIS
    Script for use with OSDCloud to deploy Windows 11 Enterprise. 
    This script cleans up items that were left by OSDCloud (Logs, Drivers, etc)
    It moves important log files to the IntuneManagementExtension folder, so we can remotely pull these logs via Intune if required 
.FUNCTIONALITY
    OSDCloud OOBE Cleanup Script
.NOTES
    Author: LZV
    Last Edit: 2024-03-25
    Version 1.0 - Creation
    Version 1.1 - Commented out removal of the OSDCloud folder for troubleshooting reasons and cleaned up script
#>

# Set global variables
$Global:Transcript = "$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Cleanup-Script.log"

# Start Transcript
Start-Transcript -Path (Join-Path "$env:ProgramData\Microsoft\IntuneManagementExtension\Logs\OSD\" $Global:Transcript) -ErrorAction Ignore

# Write Host to inform of what we are doing
Write-Host "Execute OSD Cloud Cleanup Script" -ForegroundColor Green

# Copy the OOBEDeploy and AutopilotOOBE Logs
Get-ChildItem 'C:\Windows\Temp' -Filter *OOBE* | Copy-Item -Destination 'C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\OSD' -Force
Get-ChildItem 'C:\Temp' -Filter *OOBE* | Copy-Item -Destination 'C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\OSD' -Force

# Copy OSDCloud Logs
If (Test-Path -Path 'C:\OSDCloud\Logs') {
    Move-Item 'C:\OSDCloud\Logs\*.*' -Destination 'C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\OSD' -Force
}

# Move ProgramData OSDeploy folder
Move-Item 'C:\ProgramData\OSDeploy\*.*' -Destination 'C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\OSD' -Force

# Cleanup directories
#If (Test-Path -Path 'C:\OSDCloud') { Remove-Item -Path 'C:\OSDCloud' -Recurse -Force }
If (Test-Path -Path 'C:\Drivers') { Remove-Item 'C:\Drivers' -Recurse -Force }
Get-ChildItem 'C:\Windows\Temp' -Filter *membeer*  | Remove-Item -Force

# Stop Transcript
Stop-Transcript