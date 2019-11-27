
$subscriptions = (Get-AzureRMSubscription).Id

foreach($sub in $subscriptions){
    Select-AzureRMSubscription $sub
    $vaults = Get-AzureRMRecoveryServicesVault
    foreach($vault in $vaults){
        $vault.Name
        $vault.Name >> rsvs.txt
    }
}
