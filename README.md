Cloud based SOE Deployment scripts, utilising OSDCloud

Workspace Preperation
To prepare an OSDCloud Workspace, in PowerShell, as an Admin:

### Install OSD Module
Installs the OSD Module from the PowerShell Gallery

    Install-Module -Name OSD -Force

### Import OSD Module
Imports the newly installed module into the current PowerShell Session

    Import-Module OSD

### Create a new OSDCloud Template
This creates all required files in C:\ProgramData\OSDCloud

    New-OSDCloudTemplate

### Create a new workspace, based on the template we just created
This creates the default workspace in C:\OSDCloud

    New-OSDCloudWorkspace

### Import Cloud drivers into the Workspace 
This grabs drivers for Dell computers, VMware and USB Dongles

    Edit-OSDCloudWinPE -CloudDriver Dell,VMware,USB

### Set the wallpaper
This task is entierly optional but is a nice touch

    Edit-OSDCloudWinPE -Wallpaper "C:\OSDCloud\Wallpaper.jpg"

### Set the Startup Command to launch the PowerShell Script

    Edit-OSDCloudWinPE -WebPSScript https://raw.githubusercontent.com/Swi7chb1ade/CloudSOE/main/Deploy-Scripts/Start-Deployment.ps1

### Or you can do this in one giant command

    Edit-OSDCloudWinPE -WebPSScript https://raw.githubusercontent.com/Swi7chb1ade/CloudSOE/main/Deploy-Scripts/Start-Deployment.ps1 -Wallpaper "C:\OSDCloud\Wallpaper.jpg" -CloudDriver Dell,VMware,USB
