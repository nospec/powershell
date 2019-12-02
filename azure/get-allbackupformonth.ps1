$date = (Get-Date).ToUniversalTime().AddMonths(-1)


$startofmonth = Get-Date $date -day 1 -Hour 0 -Minute 0 -Second 0

$midmonth = Get-Date $date -Day 15 -Hour 0 -Minute 0 -Second 0

$endofmonth = (($startofmonth).AddMonths(1).AddSeconds(-1))

$bruh = @()

$track = @()

$subscriptions = (Get-AzureRMSubscription).Id


    # loop through subs for all vaults in all subs
foreach($sub in $subscriptions){
    Select-AzureRMSubscription $sub

    $subName = (Get-AzureRMContext).Subscription.Name
    
    Write-Host $subName -ForegroundColor Yellow

        # loop through vaults for backup jobs
    $vaults = Get-AzureRMRecoveryServicesVault
    foreach($vault in $vaults){

    $f = 0
    $i = 0
    $count = 0
    $first = $null

    Set-AzureRMREcoveryServicesVaultContext -Vault $vault

    $first += Get-AzureRmRecoveryServicesBackupJob -From $startofmonth -To $midmonth
    $first += Get-AzureRMRecoveryServicesBackupJob -From $midmonth -To $endofmonth

    $failed = $first | Where{$_.Operation -match 'Backup' -and $_.Status -eq 'Failed'}

    $first | ? { $count++ }

    $failed | ? { $f++ }

    $total = $count - $f

    if ($failed){
            $obj = New-Object psobject -Property @{
                subscription = $subName
                vName = $vault.Name
                status = "Failed"
                operation = "Backup"
                metric = "$f / $count"
                vmName = $failed.WorkloadName
            }
            $bruh += $obj
            $tracked += $failed
    }


    Write-Host $vault.Name -ForegroundColor Blue
    Write-Host "Failed Jobs $f"
    Write-Host "Successful Jobs $total"
    Write-Host "All Jobs $count"
    


    $of += $f
    $ocount += $count
    $ototal += $total

}

}

Write-Host "Failed Jobs" -ForegroundColor Red
$bruh | Select subscription,vName, metric, operation, status, vmName
Write-Host "Total Failed Jobs $of"
Write-Host "Total Successful Jobs $ototal"
Write-Host "Total Jobs $ocount"

$tracked | Export-Csv -Path ".\failed.csv"