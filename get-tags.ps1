#Get-AzureRmSubscription
$returnObj = @()
$resourceGroups = (Get-AzureRmResourceGroup).ResourceGroupName

foreach($name in $resourceGroups){
    Write-Host $name
    Write-Host "Resources in $name"
    $bruh = Get-AzureRMResource -ResourceGroupName $name

    foreach($item in $bruh){
        $obj = new-object psobject -Property @{
            $resourceGroup = $name
            $resourceName = $item.Name
            $resourceType = $item.resourceType
            $resourceLocation = $item.Location
        }
        $returnObj += $obj
    }

    #$name = (Get-AzureRMResource -ResourceGroupName $group).Name
    #Write-Host "Name: " 
}
$returnObj | Format-Table resourceName,resourceType


#P-AUSE-RG-MABS