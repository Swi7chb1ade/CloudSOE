<#
.SYNOPSIS
    Script for use with OSDCloud to deploy Windows 11 Enterprise. 
    This script does a few fancy things. To be explained here at a later point
.FUNCTIONALITY
        OSDCloud OOBE Task kick off script
.NOTES
    Author: LZV
    Last Edit: 2024-03-07
    Version 0.1 - Creation (Alpha)
#>

# Variables for script
$scriptFolderPath = "$env:SystemDrive\OSDCloud\Scripts"
$ScriptPathOOBE = $(Join-Path -Path $scriptFolderPath -ChildPath "OOBE.ps1")
$ScriptPathSendKeys = $(Join-Path -Path $scriptFolderPath -ChildPath "SendKeys.ps1")
$serviceUIUrl = "https://raw.githubusercontent.com/Swi7chb1ade/CloudSOE/main/Tools/ServiceUIx64.exe"

# Create Script Folder Path if it does not exist
If(!(Test-Path -Path $scriptFolderPath)) {
    New-Item -Path $scriptFolderPath -ItemType Directory -Force | Out-Null
}

# Script to be run during the OOBE Process
$OOBEScript =@"
`$Global:Transcript = "`$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-OOBEScripts.log"
Start-Transcript -Path (Join-Path "`$env:ProgramData\Microsoft\IntuneManagementExtension\Logs\OSD\" `$Global:Transcript) -ErrorAction Ignore | Out-Null

Write-Host -ForegroundColor DarkGray "Executing Domain Join task"
Start-Process PowerShell -ArgumentList "-NoL -C Invoke-WebPSScript https://raw.githubusercontent.com/Swi7chb1ade/CloudSOE/main/Join-Domain.ps1" -Wait

Write-Host -ForegroundColor DarkGray "Executing Cleanup Script"
Start-Process PowerShell -ArgumentList "-NoL -C Invoke-WebPSScript https://raw.githubusercontent.com/Swi7chb1ade/CloudSOE/main/Cleanup-OSDCloud.ps1" -Wait

# Cleanup scheduled Tasks
Write-Host -ForegroundColor DarkGray "Unregistering Scheduled Tasks"
Unregister-ScheduledTask -TaskName "Scheduled Task for SendKeys" -Confirm:`$false
Unregister-ScheduledTask -TaskName "Scheduled Task for OSDCloud post installation" -Confirm:`$false

#Write-Host -ForegroundColor DarkGray "Restarting Computer"
#Start-Process PowerShell -ArgumentList "-NoL -C Restart-Computer -Force" -Wait

Stop-Transcript -Verbose | Out-File
"@

# Output the script from the variable into a file
Out-File -FilePath $ScriptPathOOBE -InputObject $OOBEScript -Encoding ascii

# Script that "Sends Keys" to the computer, to automate part of OOBE
$SendKeysScript = @"
`$Global:Transcript = "`$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-SendKeys.log"
Start-Transcript -Path (Join-Path "`$env:ProgramData\Microsoft\IntuneManagementExtension\Logs\OSD\" `$Global:Transcript) -ErrorAction Ignore | Out-Null

Write-Host -ForegroundColor DarkGray "Stop Debug-Mode (SHIFT + F10) with WscriptShell.SendKeys"
`$WscriptShell = New-Object -com Wscript.Shell

# ALT + TAB
Write-Host -ForegroundColor DarkGray "SendKeys: ALT + TAB"
`$WscriptShell.SendKeys("%({TAB})")

Start-Sleep -Seconds 1

# Shift + F10
Write-Host -ForegroundColor DarkGray "SendKeys: SHIFT + F10"
`$WscriptShell.SendKeys("+({F10})")

Stop-Transcript -Verbose | Out-File
"@

# Output the script from the variable into a file
Out-File -FilePath $ScriptPathSendKeys -InputObject $SendKeysScript -Encoding ascii

# Download ServiceUI.exe
Write-Host -ForegroundColor Gray "Download ServiceUI.exe from GitHub Repo"
Invoke-WebRequest $serviceUIUrl -OutFile "C:\OSDCloud\ServiceUI.exe"

#Create Scheduled Task for SendKeys with 15 seconds delay
$TaskName = "Scheduled Task for SendKeys"

$ShedService = New-Object -comobject 'Schedule.Service'
$ShedService.Connect()

$Task = $ShedService.NewTask(0)
$Task.RegistrationInfo.Description = $taskName
$Task.Settings.Enabled = $true
$Task.Settings.AllowDemandStart = $true

# https://msdn.microsoft.com/en-us/library/windows/desktop/aa383987(v=vs.85).aspx
$trigger = $task.triggers.Create(9) # 0 EventTrigger, 1 TimeTrigger, 2 DailyTrigger, 3 WeeklyTrigger, 4 MonthlyTrigger, 5 MonthlyDOWTrigger, 6 IdleTrigger, 7 RegistrationTrigger, 8 BootTrigger, 9 LogonTrigger
$trigger.Delay = 'PT15S'
$trigger.Enabled = $true

$action = $Task.Actions.Create(0)
$action.Path = 'C:\OSDCloud\ServiceUI.exe'
$action.Arguments = '-process:RuntimeBroker.exe C:\WINDOWS\System32\WindowsPowerShell\v1.0\powershell.exe ' + $ScriptPathSendKeys + ' -NoExit'

$taskFolder = $ShedService.GetFolder("\")
# https://msdn.microsoft.com/en-us/library/windows/desktop/aa382577(v=vs.85).aspx
$taskFolder.RegisterTaskDefinition($TaskName, $Task , 6, "SYSTEM", $NULL, 5)

# Create Scheduled Task for OSDCloud post installation with 20 seconds delay
$TaskName = "Scheduled Task for OSDCloud post installation"

$ShedService = New-Object -comobject 'Schedule.Service'
$ShedService.Connect()

$Task = $ShedService.NewTask(0)
$Task.RegistrationInfo.Description = $taskName
$Task.Settings.Enabled = $true
$Task.Settings.AllowDemandStart = $true

# https://msdn.microsoft.com/en-us/library/windows/desktop/aa383987(v=vs.85).aspx
$trigger = $task.triggers.Create(9) # 0 EventTrigger, 1 TimeTrigger, 2 DailyTrigger, 3 WeeklyTrigger, 4 MonthlyTrigger, 5 MonthlyDOWTrigger, 6 IdleTrigger, 7 RegistrationTrigger, 8 BootTrigger, 9 LogonTrigger
$trigger.Delay = 'PT20S'
$trigger.Enabled = $true

$action = $Task.Actions.Create(0)
$action.Path = 'C:\OSDCloud\ServiceUI.exe'
$action.Arguments = '-process:RuntimeBroker.exe C:\WINDOWS\System32\WindowsPowerShell\v1.0\powershell.exe ' + $ScriptPathOOBE + ' -NoExit'

$taskFolder = $ShedService.GetFolder("\")
# https://msdn.microsoft.com/en-us/library/windows/desktop/aa382577(v=vs.85).aspx
$taskFolder.RegisterTaskDefinition($TaskName, $Task , 6, "SYSTEM", $NULL, 5)
