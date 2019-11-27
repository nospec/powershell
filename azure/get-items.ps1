$bruh = Get-AzureRMResource -ResourceGroupName p-ause-rg-mabs
$returnObj = @()

foreach($item in $bruh){
    $obj = New-Object psobject -Property @{
        ResourceGroupName = $item.ResourceGroupName
        resourceName = $item.Name
        resourceLocation = $item.Location
        resourceType = $item.resourceType
    }
    $returnObj += $obj
}
$returnObj | Format-Table resourceName, ResourceGroupName, resourceLocation, resourceType
    # $item.Name 
    # Write-Host "Location: "
    # $item.Location
    # Write-Host "Resource Type: "
    # $item.resourceType 


    # foreach($item in $bruh){
    #     $obj = new-object psobject -Property @{
    #         $resourceGroup = $name
    #         $resourceName = $item.Name
    #         $resourceType = $item.resourceType
    #         $resourceLocation = $item.Location
    #     }
    #     $returnObj += $obj
    # }