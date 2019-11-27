# $resourceGroup = (Get-AzureRMResourceGroup).ResourceGroupName

#(Get-AzureRMResource -ResourceGroupName p-ause-rg-mabs).Name

$resourceGroup = (Get-AzureRmResourceGroup).ResourceGroupName
$returnObj = @()
$tagger = ""

foreach($group in $resourceGroup){
    $resources = (Get-AzureRmResource -ResourceGroupName $group).Name

    foreach($r in $resources){ 
        $tag = (Get-AzureRMResource -Name $r).Tags
    }
    # foreach($r in $resources){
    #     $tags = (Get-AzureRMResource -ResourceGroupName $group -Name $r).Tags
    #     if ($tags){ 
    #         $tags.GetEnumerator() | % { $tagger += $_.Key + ":" + $_.Value + ";"}
    #     }
    #     else { $tagger = "Null"}

    # $obj = New-Object psobject -Property @{
    #      resourceGroup = $r.ResourceGroupName
    #      resourceName = $r.Name
    #      resourceLocation = $r.Location 
    #      resourceType = $r.resourceType
    #      tags = $tagger
    #  }
    #  $returnObj += $obj

    #  $tagger = ""
    # }
    #  $returnObj
}

