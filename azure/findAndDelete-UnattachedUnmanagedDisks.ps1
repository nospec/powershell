$tentants = (Get-AzureRmSubscription).Id 

foreach($tenant in $tentants){
    Select-AzureRMSubscription $tenant

    $storageAccounts = Get-AzureRmStorageAccount
$wholeObj = @()
foreach($storageAccount in $storageAccounts){
    $san = $storageAccount.StorageAccountName
    $group = $storageAccount.ResourceGroupName
    $sku = $storageAccount.Sku.Name

    $redundancy = $sku -replace "Standard*"

    $storageKey = (Get-AzureRMStorageAccountKey -ResourceGroupName $storageAccount.ResourceGroupName -Name $storageAccount.StorageAccountName)[0].Value
    $context = New-AzureStorageContext -StorageAccountName $storageAccount.StorageAccountName -StorageAccountKey $storageKey
    $containers = Get-AzureStorageContainer -Context $context
    foreach($container in $containers){
        $blobs = Get-AzureStorageBlob -Container $container.Name -Context $context

        # fetch all the page blobs with extension .vhd as only Page blobs can be attached as disk to Azure VMs
        if($blobs){
        $blobs | Where-Object{$_.BlobType -eq 'PageBlob' -and $_.Name.EndsWith('.vhd')} | ForEach-Object {
            # if a page blob is not attached as disk then LeaseStatus will be unlocked
            if($_.ICloudBlob.Properties.LeaseStatus -eq 'Unlocked'){

                $obj = New-Object psobject -Property @{
                    subscriptionID = $tenant
                    ResourceGroupName = $group
                    StorageAccountName = $san
                    Tier = $sku
                    Redundancy = $redundancy
                    StorageContainerName = $container.Name
                    Kind = $storageAccount.Kind
                    BlobName = $_.Name
                    Size = $_.Length
                }
                $wholeObj += $obj
                $obj
            }
        }
        }
    }
}
if($wholeObj){ 
    
    $wholeObj | Export-CSV ".\snapshots.CSV" 
    foreach($item in $wholeObj){
        Write-Host 'container ' + $item.StorageContainerName + ' blob ' + $item.BlobName
        Remove-AzureStorageBlob -Container $item.StorageContainerName -Blob $item.BlobName
        }
}
}

