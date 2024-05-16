<#
.SYNOPSIS
    Script that runs on the first boot / first login after OSDCloud finishes installing Windows 11
    Currently the script:
    -Installs Dell Command Update
    -Cleans up behind OSDCloud  
    This can be expanded upon in future
.FUNCTIONALITY
    OSDCloud OOBE Automation Script
.NOTES
    Author: LZV
    Last Edit: 2024-05-01
    Version 0.1 - Creation (Alpha)
    Version 1.0 - Out of beta, validated working
#>

# Script to be run during the OOBE Process
$Global:Transcript = "$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-OOBEScripts.log"
Start-Transcript -Path (Join-Path "$env:ProgramData\Microsoft\IntuneManagementExtension\Logs\OSD\" $Global:Transcript) -ErrorAction Ignore | Out-Null

# Dell Command | Update Install
Write-Host -ForegroundColor DarkGray "Executing Dell Command Update Install Task"
Start-Process PowerShell -ArgumentList "-NoL -C Invoke-WebPSScript 'https://ablcloudsoe.blob.core.windows.net/`$web/OOBE-Scripts/Install-DCU.ps1'" -Wait

# ScreenConnect Install
Write-Host -ForegroundColor DarkGray "Executing ScreenConnect Install Task"
Start-Process PowerShell -ArgumentList "-NoL -C Invoke-WebPSScript 'https://ablcloudsoe.blob.core.windows.net/`$web/OOBE-Scripts/Install-SC.ps1'" -Wait

# Template for next task
#Write-Host -ForegroundColor DarkGray "Executing XYZ Task"
#Start-Process PowerShell -ArgumentList "-NoL -C Invoke-WebPSScript 'https://ablcloudsoe.blob.core.windows.net/`$web/OOBE-Scripts/XYZ.ps1'" -Wait

# OSDCloud Cleanup Task
Write-Host -ForegroundColor DarkGray "Executing Cleanup Script"
Start-Process PowerShell -ArgumentList "-NoL -C Invoke-WebPSScript 'https://ablcloudsoe.blob.core.windows.net/`$web/OOBE-Scripts/Cleanup-OSDCloud.ps1'" -Wait

# Cleanup scheduled Tasks
Write-Host -ForegroundColor DarkGray "Unregistering Scheduled Tasks"
Unregister-ScheduledTask -TaskName "Scheduled Task for SendKeys" -Confirm:$false
Unregister-ScheduledTask -TaskName "Scheduled Task for OSDCloud post installation" -Confirm:$false

# Reboot computer one last time
Write-Host -ForegroundColor DarkGray "OOBE Tasks completed! Restarting Computer in 30 seconds"
Start-Sleep -Seconds 30
Stop-Transcript -Verbose | Out-File
Start-Process PowerShell -ArgumentList "-NoL -C Restart-Computer -Force" -Wait