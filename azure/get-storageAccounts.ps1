# $sas = Get-AzureRMResource -ResourceType Microsoft.Storage/storageAccounts
# $bruh = @()
# foreach($sa in $sas){
#     $i++
#     $group = $sa.ResourceGroupName
#     $name = $sa.Name
#     $location = $sa.Location
#     $kind = $sa.Kind

#     $obj = New-Object psobject -Property @{
#         name = $name
#         group = $group
#         location = $location
#         kind = $kind
#     }
#     $bruh += $obj

# }

# write-host "$i storage accounts"
# $bruh

$storageAccountName = ""

$storageAccountKey = Get-AzureRMStorageAccountKey -ResourceGroupName  -name 

$CTX = New-AzureStorageContext $storageAccountName -StorageAccountKey $storageAccountKey.Value[1]

$containerName = "vhds"

# Get-AzureStorageBlob -Container $containerName -Context $CTX | Select *

Get-AzureStorageBlob -Container $containerName -Context $CTX | Select *

# Get-AzureStorageContainer -Container $containerName -Context $CTX | Select *

# Get-AzureRMStorageAccount -ResourceGroupName  -Name  | Select *

# Get-AzureRMStorageAccountKey -ResourceGroupName -Name


# Get-AzureRMStorageContainer -ResourceGroupName -StorageAccountName 

# Get-AzureRMStorageContainer -ResourceGroupname -StorageAccountName 

# Get-AzureStorageBlob -Container "insights-logs-azuresiterecoveryevents"

