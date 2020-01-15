

$subs = (Get-AzureRmSubscription).Id

foreach($sub in $subs){
Select-AzureRmSubscription -Subscription $sub

    $vms = Get-AzureRmVm
    $fullObject = @()
    
    foreach($vm in $vms){
    $obj = new-object psobject -Property @{
        vmName = $vm.Name
        Sku = $vm.StorageProfile.ImageReference.Sku
    }
    $fullObject += $obj
    }

}

$fullObject