$tenants = (Get-AzureRMSubscription).Id
$i = 0; 
$t = 0; 
$s = 0;

foreach($tenant in $tenants){
    Select-AzureRMSubscription $tenant


    $rgs = @()
    $wholeObj = @()
    $resources = @()
    $san = @()

    
    $track = @()


    
    # sub logic bruh
        # get sans from specific group
        $groups = Get-AzureRmResourceGroup
        $groups | Where-Object {$_.ResourceGroupName -Match "sap"} | ForEach-Object {$rgs+=$_.ResourceGroupName}


        foreach($group in $rgs){
            $resources += Get-AzureRMResource -ResourceGroupName $group
        }
        $san += $resources | Where-Object {$_.Type -Match "storageAccounts"}
        

    foreach($sa in $san){
        $sanN = $sa.Name
        $g = $sa.ResourceGroupName
     
        $storageKey = (Get-AzureRMStorageAccountKey -ResourceGroupName $g -Name $sanN)[0].Value
        $context = New-AzureStorageContext -StorageAccountName $sanN -StorageAccountKey $storageKey
        $containers = Get-AzureStorageContainer -Context $context
        foreach($container in $containers){
            $blobs = Get-AzureStorageBlob -Container $container.Name -Context $context

            foreach($blob in $blobs){
                # if($blob.BlobType -match "")
                if($blob.BlobType -match "BlockBlob"){
                    $i++
                }
                if($blob.BlobType -match "PageBlob"){
                    $t++
                }
                if($blob.BlobType -match "AppendBlob"){
                    $s++
                }
                else{
                    $track += $blob.BlobType
                }
                
            }

            $obj = New-Object psobject -Property @{
                Subscription = $tenant
                ResourceGroup = $g
                StorageAccount = $sanN
                Container = $container.Name
                BlobType = $blob.BlobType
            }
            $wholeObj += $obj

        }

    }
$wholeObj

}

Write-Host "Block Blob = $i"
Write-Host "Page Blob = $t"
Write-Host "AppendBlob = $s"
Write-Host "Everything Else = $track"