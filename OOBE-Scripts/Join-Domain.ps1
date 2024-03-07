# Join Domain

$assetName = Get-Content "C:\OSDCloud\AssetName.txt"
Rename-Computer -NewName $assetName

#Add-Computer -NewName $assetName -DomainName "abl.com.au" 
