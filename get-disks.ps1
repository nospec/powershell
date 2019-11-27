## 

$tenants = (Get-AzureRmSubscription).Id

foreach($tenant in $tenants){
    Select-AzureRMSubscription $tenant

    $re = Get-AzureRMResource
    # initialize $i
    $i = 0
    $t = 0
    $s = 0
    $tenantName = (Get-AzureRMContext).Name -replace '\(.*'

    # $tagged = @()

    # how many disks
    foreach($item in $re){
        # is the item a disk?
        $type = $item.Type | Select-String -Pattern "Microsoft.Compute/disks"

        if($type){
                $tags = $item.Tags
                $managed = $item.ManagedBy
                
                if($tags){
                    $tags.GetEnumerator() | % { $tagger += $_.Key + ":" + $_.Value + ";"}
                    # check if tagged by ASR
                    $test = $tagger | Select-String -Pattern "ASR-ReplicaDisk"
                    # doesn't have ASR tagged and not managedBy
                    if(!$test -And !$managed){
                        $i++
                    }
                    if($managed -And !$test){
                        $s++
                    }
                    else{ $t++}
                }
            }
    }
    Write-Host "Current Subscription $tenantName"
    Write-Host "Total Disks not tagged by ASR and unattached: $i"
    Write-Host "Total Disks Attached and Untagged by ASR: $s"
    Write-Host "Total Disks managed by ASR: $t"

}




#$item = Get-AzureRmResource -ResourceType Microsoft.Compute/disks -ResourceGroupName p-auea-711-rg-sap-oap | Select ManagedBy | Select-String "Microsoft.Compute/virtualMachines"

#$item -replace ".*/" -replace "}*"