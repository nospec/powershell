

# get - subs 
$subs = (Get-AzureRmSubscription).Id
$bruh = @()


foreach($sub in $subs){
    Select-AzureRmSubscription $sub
    
$VMS = Get-AzureRmVM
Foreach($vm in $VMS){
    $hub = $vm.LicenseType
    if($hub -eq $null){
        $vmHUB = "Disabled"
    }
    else{
        $vmHUB = "Enabled"
    }

    $obj = New-Object psobject -Propert @{
        vmName = $vm.Name
        vmRG = $vm.ResourceGroupName
        vmOSPub = $vm.StorageProfile.ImageReference.Publisher
        vmOSOffer = $vm.StorageProfile.ImageReference.Offer
        vmOSsku = $vm.StorageProfile.ImageReference.Sku
        vmHUBstatus = $vmHUB
    }
$bruh += $obj
}
}
#business end
$bruh | select vmName,vmOSsku,vmOSPub,vmOSOffer,vmHUBstatus | ft