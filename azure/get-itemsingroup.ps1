$resourceGroup = (Get-AzureRMResourceGroup).ResourceGroupName

foreach($item in $resourceGroup){
    # Write-Host $item
    $resource = Get-AzureRMResource -ResourceGroupName $item
    $returnObj = @()

    $tagger = ""
    
    foreach($bro in $resource){
        # get tags
        $tags = (Get-AzureRmResource -ResourceGroupName $item -Name $bro).Tags
 
        if ($tags -ne $null) {
            $tags.GetEnumerator() | % { $tagger += $_.Key + ":" + $_.Value + ";"}
        }
        else {
            $tagger = "NULL"    
        }

        $obj = New-Object psobject -Property @{
             resourceGroup = $item
             resourceName = $bro.Name
             resourceLocation = $bro.Location
             resourceType = $bro.resourceType
             tags = $tagger
         }
        $returnObj += $obj

        $tagger = ""
    }
    # Write-Host $item
    $returnObj
    # $returnObj
    # $newhash.Add("$item",$returnObj)

}
}


$resourceGroup = (Get-AzureRMResourceGroup).ResourceGroupName

(Get-AzureRMResource -ResourceGroupName p-ause-rg-mabs).Name

$Tags = (Get-AzureRMResource -ResourceGroupName p-ause-rg-mabs -Name p-ause-as-mabs-01).Tags
if ($Tags -ne $null) {
    $Tags.GetEnumerator() | % { $resourceTagString += $_.Key + ":" + $_.Value + ";" 
}
else {
    $tagger = "Null"
}


