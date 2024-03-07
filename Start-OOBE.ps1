# Determine if Desktop or Mobile computer
$hardwareType = (Get-Computerinfo).CsPCSystemType
if($hardwareType -eq "Desktop"){
    $prefix = "PC"
}
elseif($hardwareType -eq "Mobile"){
    $prefix = "NB"
}

# Prompt for Asset Tag Number
Add-Type -AssemblyName Microsoft.VisualBasic
$title = "Computer Name"
$message   = 'Enter the computer asset number:'
$assetNumber = [Microsoft.VisualBasic.Interaction]::InputBox($message, $title)

# Create Asset Name variable
$assetName = $prefix + $assetNumber
