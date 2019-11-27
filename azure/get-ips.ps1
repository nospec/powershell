# Get-AzureRMPublicIpAddress

# $tenants = Get-AzureRmSubscription

# foreach($tenant in $tenants){
#     Get-AzureRMPublicIpAddress
# }


$resource = get-azurermresource
foreach($re in $resource){
    $type = $re.Type | Select-String -Pattern "Microsoft.Network/publicIPAddresses"

    if($type){
        $i++
        $re | select *
    }
}
write-host "$i public ip addresses"
