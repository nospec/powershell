$obj = @()

$storageAccounts = Get-AzureRMStorageAccount

foreach($storageAccount in $storageAccounts){
    $storageKey = (Get-AzureRMStorageAccountKey -ResourceGroupName $storageAccount.ResourceGroupName -Name $storageAccount.StorageAccountName)[0].Value
    $context = New-AzureStorageContext -StorageAccountName $storageAccount.StorageAccountName -StorageAccountKey $storageKey
    $containers = Get-AzureStorageContainer -Context $context
    foreach($container in $containers){
        $blobs = Get-AzureStorageBlob -Container $container.Name -Context $context

        $blobs | Where-Object{$_.BlobType -eq 'PageBlob' -and $_.Name.EndsWith('.vhd')} | ForEach-Object {
            if($_.ICloudBlob.Properties.LeaseStatus -eq 'Unlocked'){
                $object = New-Object psobject -Property @{
                    # subscriptionID = 
                    ResourceGroup = $storageAccount.ResourceGroupName
                    StorageAccountName = $storageAccount.StorageAccountName
                    StorageContainerName = $container.Name
                    BlobName = $_.Name
                    Type = $_.BlobType
                    Length = $_.Length
                    LeaseStatus = $_.ICloudBlob.Properties.LeaseStatus
                }
                $obj += $object
            }
        }
    }
}
Write-Host "$i total bobs"
$obj | Select *