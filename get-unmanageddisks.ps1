# stephane mathieu
# 22/10/19
######
# AzureRM --- module
# find all disks in azure account within all subs 
# identify which ones are unmanaged/unattached

# subscription logic
# $tenants = (Get-AzureRMSubscription).Id

# foreach($tenant in $tenants){
#     Select-AzureRMSubscription $tenant

#     $tenantName = (Get-AzureRMContext).Name

    $disks = Get-AzureRMDisk
    $fullObject = @()
    
    foreach($disk in $disks){ 
        $name = $disk.Name
        $group = $disk.ResourceGroupName
        # $attached = $disk.ManagedBy
        $tags = $disk.Tags

        if($tags){
            $tags.GetEnumerator() | % { $tagger += $_.Key + ":" + $_.Value + ";" }

            $test = $tagger | Select-String -Pattern "ASR-ReplicaDisk"

            if(!$test) {
                $result = "NO"
                Write-Host "Disk Name: $name" -BackgroundColor White -ForegroundColor Black
                Write-Host "Group: $group"
                Write-Host "Attached: $result" -ForegroundColor Red
                $obj = new-object psobject -Property @{
                    name = $name
                    group = $group
                    # managedBy = $disk.ManagedBy
                    attached = $result
                    # subscription = $tenantName
                }
                $fullObject += $obj
                $obj = $null
                $test = $null
                $tagger = $null
            }
        }
    # $fullObject
    $fullObject | Export-Csv "C:\Users\SMathieu\_dump\azure\disks.csv"
    }
