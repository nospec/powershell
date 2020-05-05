# $disk = get-azurermdisk 

# $1tb = $disk | Where-Object {$_.DiskSizeGB -gt 1023}
# $1tb | Where-Object {$_.Sku -match "Premium"}


# $diskoverlimit | Select ResourceGroupName,DiskSizeGB,DiskState,Name,Location,Sku | Format-Table -AutoSize
$disks= Get-AzDisk
$diskoverlimit = $disks | where-object {$_.DiskSizeGB -gt 1000}
$array = @()
ForEach ($disk in $diskoverlimit) {
    $newobj = new-object psobject -Property @{
        ResourceGroup = $disk.ResourceGroupName
        DiskSize = $disk.DiskSizeGB
        DiskSta = $disk.DiskState
        Name = $disk.Name
        Location = $disk.Location
        Sku = $disk.Sku.Name
    }
    $array += $newobj
}
$array | ft