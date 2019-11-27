# $disks = Get-AzureRMDisk


# UNFINISHED ---------

$tenant = (Get-AzureRMContext).Name

$resources = Get-AzureRMResource

$untagged = @()

$owned = @()
$unOwned = @()
$taggedOwned =@()
$taggedUnOwned = @()

$uu = 0
$uc = 0
$nu = 0

foreach($disk in $resources){
    $diskT = $disk.Type | Select-String -Pattern "Microsoft.Compute/disks"
    if($diskT){
        # track # of disks
        $dt++
        # gets tags from disk
        $tags = $disk.Tags 
        # gets the managedBy property of disk
        $managed = $disk.ManagedBy

        # get disk owner details
        $owner = $managed -replace ".*/" -replace "}*"

        # check if tagged
        if($tags){
            # track tagged disks
            $t++
            # turn tags into string array
            $tags.GetEnumerator() | % { $tagger += $_.Key + ":" + $_.Value + ";"}
            # find if tagged with ASR-ReplicaDisk
            $test = $tagger | Select-String -Pattern "ASR-ReplicaDisk"
            # if not tagged with ASR-ReplicaDisk
            if(!$test){
                # not tagged ASR-ReplicaDisk and connected
                if ($managed) {
                    # track non ASR-ReplicaDisks and Connected
                    $m++
                    # add disk details to object array
                    $objec = New-Object psobject -Property @{
                        name = $disk.Name
                        group = $disk.ResourceGroupName
                        vmOwner = $owner
                        tags = $tagger
                    }
                    # push to array
                    $taggedOwned += $objec
                    #$objec
                }
                # not tagged with ASR-ReplicaDisk and not connected
                else {
                    # track not tagged ASR-ReplicaDisks and not connected
                    $nu++
                    # add disk details to object array
                    $obj = New-Object psobject -Property @{
                        name = $disk.Name
                        group = $disk.ResourceGroupName
                        vmOwner = "none"
                        tags = $tags
                    }
                    # push object to array
                    $taggedUnOwned += $obj
                }
            }
            # if tagged with ASR-ReplicaDisk
            else {
                # track tagged ASR-ReplicaDisks
                $s++
                #do nothing
            }
        }
        # untagged disks
        else {
            # track number of untagged disks
            $ut++
            # connected disks
            if($managed){
                # track number of untagged connected disks
                $uc++
                # disk details to object array
                $obje = New-Object psobject -Property @{
                    vmOwner = $owner
                    name = $disk.Name
                    group = $disk.ResourceGroupName
                }
                # push object to array
                $owned += $obje
            }
            # unconnected disks
            else {
                # track number of untagged unconnected disks
                $uu++
                # disk details to object array
                $obj = New-Object psobject -Property @{
                    name = $disk.Name
                    group = $disk.ResourceGroupName
                    vmOwner = "none"
                }
                # push object to array
                $unOwned += $obj
            }
            # $u++
            # $obj = New-Object psobject -Property @{
            #     name = $disk.Name
            #     group = $disk.ResourceGroupName
            #     tags = $disk.Tags
            # }
            # $untagged += $obj
        }

        # if($managed){
        #     $i++
        # }
        # elseif($managed -And $tags){ 

        # }
        # elseif (!$managed) {
        #     $n++
        # }

        # if($managed -And $tags){
        #     $tags.GetEnumerator() | % { $tagger += $_.Key + ":" + $_.Value + ";"}
        #     $test = $tagger | Select-String -Pattern "ASR-ReplicaDisk"
        #     if(!$test){
        #         $i++
        #     }
        # }
        # $i++
        # $tags.GetEnumerator() | % { $tagger += $_.Key + ":" + $_.Value + ";"}
        # $test = $tagger | Select-String -Pattern "ASR-ReplicaDisk"
        # if(!$test){
        #     $b++
        # }
        # } 
    }
}
Write-Host "Total Disks:                                        $dt"
Write-Host "Tagged Disks:                                       $t"
#Write-Host "Untagged Disks:                                     $ut"
#Write-Host "Not Tagged with ASR-DiskReplica and Connected:      $m"
Write-Host "Tagged with ASR-DiskReplica:                        $s"
#Write-Host "Not tagged with ASR-DiskReplica and not connected   $nu"
Write-Host "Untagged and Connected                              $uc"
#Write-Host "Untagged and Unconnected                            $uu"
Write-Host " "
Write-Host "Non ASR-DiskReplica Disks and Connected:            $m" -BackgroundColor White -ForegroundColor Black
$taggedOwned | Select name, group, vmOwner | FT
Write-Host "Non ASR-DiskReplica and Not Connected:              $nu" -BackgroundColor White -ForegroundColor Black
$taggedUnOwned | Select name, group, tags | FT
Write-Host "Untagged Connected Disks:                           $ut" -BackgroundColor White -ForegroundColor Black
$owned | FT
Write-Host "Untaged and Unconnected Disks:                    $uu"
# $owned
# Write-Host "$t disks in $tenant"
# Write-Host "not managedby asr: $b"
# Write-Host "unamanaged disks: $n"