# account level logic
$tenants = (Get-AzureRMSubscription).Id


foreach($tenant in $tenants){
    Select-AzureRMSubscription $tenant

    $tenantName = (Get-AzureRMContext).Name

    $vms = Get-AzureRMVM -Status | Select *
    $i = 0
    $s = 0
    $r = 0

    foreach($vm in $vms){
        $allocated = $vm.PowerState | Select-String -Pattern "deallocated"
        $stopped = $vm.PowerState | Select-String -Pattern "stopped"
        # deallocated hosts
        if($allocated){
            $i++
        }
        # stopped hosts
        if($stopped){
            $s++
        }
        # running hosts
        else { $r++}
    }
    Write-Host "Tenant: $tenantName" -ForegroundColor Black -BackgroundColor White
    write-host "deallocated hosts: $i"
    write-host "stopped hosts: $s"
    write-host "running hosts: $r"
}

Write-Host ".... Complete ...." -ForegroundColor DarkBlue -BackgroundColor White