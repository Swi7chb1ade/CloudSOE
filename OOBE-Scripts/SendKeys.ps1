<#
.SYNOPSIS
    Script that "Sends Keys" to the computer, to automate part of OOBE
.FUNCTIONALITY
    Sends keys using wscript.shell for OOBE Automation
.NOTES
    Author: LZV
    Last Edit: 2024-05-01
    Version 0.1 - Creation (Alpha)
    Version 0.2 - Updated to point to ablcloudsoe Azure storage
    Version 1.0 - Out of Alpha, validated working
#>

# Start Transcript
$Global:Transcript = "$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-SendKeys.log"
Start-Transcript -Path (Join-Path "$env:ProgramData\Microsoft\IntuneManagementExtension\Logs\OSD\" $Global:Transcript) -ErrorAction Ignore | Out-Null

# Stop Debug mode 
Write-Host -ForegroundColor DarkGray "Stop Debug-Mode (SHIFT + F10) with WscriptShell.SendKeys"
$WscriptShell = New-Object -com Wscript.Shell

# ALT + TAB
Write-Host -ForegroundColor DarkGray "SendKeys: ALT + TAB"
$WscriptShell.SendKeys("%({TAB})")

# Sleep for 1 Second
Start-Sleep -Seconds 1

# Shift + F10
Write-Host -ForegroundColor DarkGray "SendKeys: SHIFT + F10"
$WscriptShell.SendKeys("+({F10})")

# Stop Transcript
Stop-Transcript -Verbose | Out-File