# Join Domain

$assetName = Get-Content "C:\OSDCloud\AssetName.txt"

Add-Computer -NewName $assetName -DomainName "abl.com.au" 
