:: SetupComplete file for Windows 11
:: Author: LZV
:: Last Edit: 2024-05-01
:: Version 0.1 - Creation
:: Version 0.2 - Updated to point to ablcloudsoe Azure storage
:: Version 1.0 - Out of Alpha, validated working

powershell.exe -command Set-ExecutionPolicy Unrestricted -Force
powershell.exe -command "& {IEX (IRM https://ablcloudsoe.blob.core.windows.net/`$web/OOBE-Scripts/Start-OOBE.ps1)}