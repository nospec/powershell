# gets all disks
# checks if they're attached
# checks if the unattached disks are Azure ASR related

$currentDir = pwd

$i = 0
$u = 0
$t = 0

$tagged = @()
$untagged = @()
#$hosts = @()

$tenants = (Get-AzureRmSubscription).Id

foreach($tenant in $tenants){
    Select-AzureRMSubscription $tenant

    $disks = Get-AzureRmDisk

    foreach($disk in $disks){
        $connected = $disk.ManagedBy
    
        if($connected){
            $i++
        }
        else{
            $u++
            $tags = $disk.Tags
            if($tags){
                $tags.GetEnumerator() | % { $tagger += $_.Key + ":" + $_.Value + ";" }
                $test = $tagger | Select-String -Pattern "ASR"
                if(!$test){
                    $tagged += $disk.Name,$disk.ResourceGroupName
                }
                else { $a++}
            }
            else {
                $untagged += $disk.Name
            }
        }
    }
}




$t = $i + $u
Write-Host "Total Disks: $t"
Write-Host "Connected Disks: $i"
Write-Host "Disconnected disks: $u"
$tagged
Write-Host "Disconnected ASR Disks: $a"
Write-Host "Untagged: " -ForegroundColor Black -BackgroundColor White
$untagged
if($untagged){
    $untagged | export-csv "$currentdir\untagged-disconnected-disks.csv"
}

