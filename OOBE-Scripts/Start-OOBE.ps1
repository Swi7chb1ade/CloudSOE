<#
.SYNOPSIS
    Script to set up First Boot / First Login actions
    This script will:
    -Download Key Files (ServiceUI.exe, OOBE.ps1 and SendKeys.ps1)
    -Create a scheduled task to "SendKeys" using the ServiceUI
    -Create a scheduled task to run the actual OOBE Setup 
.FUNCTIONALITY
    OSDCloud OOBE Task kick off script
.NOTES
    Author: LZV
    Last Edit: 2024-05-01
    Version 0.1 - Creation (Alpha)
    Version 0.2 - Updated to point to ablcloudsoe Azure storage
    Version 0.3 - Updated and split out the scripts - this was causing issues
    Version 1.0 - Out of Alpha, validated working
#>

# Variables for script
$oobeScriptUrl = "https://ablcloudsoe.blob.core.windows.net/`$web/OOBE-Scripts/OOBE.ps1"
$sendKeysScriptUrl = "https://ablcloudsoe.blob.core.windows.net/`$web/OOBE-Scripts/SendKeys.ps1"
$serviceUIUrl = "https://ablcloudsoe.blob.core.windows.net/`$web/Resources/ServiceUIx64.exe"
$osdcloudFolderPath = "$env:SystemDrive\OSDCloud"
$scriptFolderPath = $(Join-Path -Path $osdcloudFolderPath -ChildPath "Scripts")
$scriptPathOOBE = $(Join-Path -Path $scriptFolderPath -ChildPath "OOBE.ps1")
$scriptPathSendKeys = $(Join-Path -Path $scriptFolderPath -ChildPath "SendKeys.ps1")
$pathServiceUI = $(Join-Path -Path $osdcloudFolderPath -ChildPath "ServiceUI.exe")

# Create Script Folder Path if it does not exist
If(!(Test-Path -Path $scriptFolderPath)) {
    New-Item -Path $scriptFolderPath -ItemType Directory -Force | Out-Null
}

# Copy OOBE.ps1 from Azure Storage
Write-Host -ForegroundColor Green "Copying OOBE.ps1 script from Azure Storage"
Invoke-WebRequest $oobeScriptUrl -outFile $scriptPathOOBE

# Copy SendKeys.ps1 from Azure Storage 
Write-Host -ForegroundColor Green "Copying SendKeys.ps1 script from Azure Storage"
Invoke-WebRequest $sendKeysScriptUrl -outFile $scriptPathSendKeys

# Download ServiceUI.exe
Write-Host -ForegroundColor Gray "Download ServiceUI.exe from GitHub Repo"
Invoke-WebRequest $serviceUIUrl -OutFile $pathServiceUI

# Create Scheduled Task for SendKeys with 15 seconds delay
$TaskName = "Scheduled Task for SendKeys"

$ShedService = New-Object -comobject 'Schedule.Service'
$ShedService.Connect()

$Task = $ShedService.NewTask(0)
$Task.RegistrationInfo.Description = $taskName
$Task.Settings.Enabled = $true
$Task.Settings.AllowDemandStart = $true

$trigger = $task.triggers.Create(9) # 0 EventTrigger, 1 TimeTrigger, 2 DailyTrigger, 3 WeeklyTrigger, 4 MonthlyTrigger, 5 MonthlyDOWTrigger, 6 IdleTrigger, 7 RegistrationTrigger, 8 BootTrigger, 9 LogonTrigger
$trigger.Delay = 'PT15S'
$trigger.Enabled = $true

$action = $Task.Actions.Create(0)
$action.Path = 'C:\OSDCloud\ServiceUI.exe'
$action.Arguments = '-process:RuntimeBroker.exe C:\WINDOWS\System32\WindowsPowerShell\v1.0\powershell.exe ' + $ScriptPathSendKeys + ' -NoExit'

$taskFolder = $ShedService.GetFolder("\")
$taskFolder.RegisterTaskDefinition($TaskName, $Task , 6, "SYSTEM", $NULL, 5)

# Create Scheduled Task for OSDCloud post installation with 20 seconds delay
$TaskName = "Scheduled Task for OSDCloud post installation"

$ShedService = New-Object -comobject 'Schedule.Service'
$ShedService.Connect()

$Task = $ShedService.NewTask(0)
$Task.RegistrationInfo.Description = $taskName
$Task.Settings.Enabled = $true
$Task.Settings.AllowDemandStart = $true

$trigger = $task.triggers.Create(9) # 0 EventTrigger, 1 TimeTrigger, 2 DailyTrigger, 3 WeeklyTrigger, 4 MonthlyTrigger, 5 MonthlyDOWTrigger, 6 IdleTrigger, 7 RegistrationTrigger, 8 BootTrigger, 9 LogonTrigger
$trigger.Delay = 'PT20S'
$trigger.Enabled = $true

$action = $Task.Actions.Create(0)
$action.Path = 'C:\OSDCloud\ServiceUI.exe'
$action.Arguments = '-process:RuntimeBroker.exe C:\WINDOWS\System32\WindowsPowerShell\v1.0\powershell.exe ' + $ScriptPathOOBE + ' -NoExit'

$taskFolder = $ShedService.GetFolder("\")
$taskFolder.RegisterTaskDefinition($TaskName, $Task , 6, "SYSTEM", $NULL, 5)