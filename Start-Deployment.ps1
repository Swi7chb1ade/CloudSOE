Write-Host -ForegroundColor Green "Starting ABL OSDCloud Zero Touch Install"
Start-Sleep -Seconds 5
Write-Host -ForegroundColor Red "Please remove USB From computer NOW - Press Enter when done"
pause

Start-OSDCloud -OSVersion 'Windows 11' -OSBuild 23H2 -OSLanguage en-us -OSEdition Enterprise -OSActivation Volume
