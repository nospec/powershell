    # get all subs
    $tenants = (Get-AzureRmSubscription).Id
    $readyToDelete = @()
    # cycle through each subscription
    
    
    # initialise variable
    $count = 0
    $countSnaps = 0
    foreach ($tenant in $tenants){

        # select the correct azure sub
        Select-AzureRMSubscription $tenant
        # get sub name
        $tenantName = (Get-AzureRMContext).name

        # grab the snapshot details
        $getIt = Get-AzureRMSnapshot

        # create array to holdtag info
        $tagger = @()
        # create info to hold snapshots without Snapshot Tag
        $noSnapshot = @()

        # snapshot tracker 
        # initialise variable
        $i = 0
        # loop through each snapshot in Snapshots object
        foreach($item in $getIt){
            # open an empty variable for the tagger
            $tagger = ""
            # store all the tag info for each item
            $tags=$item.Tags
            # check if there are tags in this resource
            if($tags){
                # if there are tags in the resource
                # assign each tag to the tagger array
                $tags.GetEnumerator() | % { $tagger += $_.Key + ":" + $_.Value + ";"}
                
                # check if the snapshot tags contain Snapshot:True tags
                $test = $tagger | Select-String -Pattern "Snapshot:True"
                
                # if it doesn't have Snapshot:True tag
                # Assign it to noSnapshot Array
                if(!$test){
                    $obj = new-object psobject -Property @{
                        name = $item.Name
                        subscription = $tenantName
                        sizeGb = $item.DiskSizeGB
                        group = $item.ResourceGroupName
                        osType = $item.OsType
                        tags = $tagger
                    }
                    $noSnapshot += $obj
                }
                # if it does, do nothing
                else {}
            }
            # if there are no tags, assign null to tagger var
            else { $tagger="Null"}

            # count how many snaps
            $i++
        }
        # noSnapshot Contains all the snapshots without the tag
        # Snapshot:True
        $readyToDelete += $noSnapshot

        # incrementals
        $countSnaps += $i
        $count += $noSnapshot.Count

        # output the count of snapshots without Snapshot:True Tags
        $out = "Snapshots with no Snapshot tag:  " + $noSnapshot.Count
        Write-Host $out -BackgroundColor Cyan -ForegroundColor Black

        # output total amount of snapshots in the current tenant
        #  Write-Host "Total Snapshots in tenant:  $i"
        # $i = $null
    }

    Write-Host " .... Completed .... " -ForeGround Green -BackgroundColor Red
    Write-Host "Total Snapshots in Account: $countSnaps" -ForegroundColor Black -BackgroundColor White
    Write-Host "Snapshots Ready for Delete: $count" -ForegroundColor Black -BackgroundColor White
    $readyToDelete | Select Name, subscription, Group, SizeGb, osType, tags | Export-Csv "C:\Users\SMathieu\_dump\azure\snaps.csv"