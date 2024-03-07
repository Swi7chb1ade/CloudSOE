:: SetupComplete file for Windows 11
powershell.exe -command Set-ExecutionPolicy Unrestricted -Force
powershell.exe -command "& {IEX (IRM https://raw.githubusercontent.com/Swi7chb1ade/CloudSOE/main/Start-OOBE.ps1)}
