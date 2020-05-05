## logic to get period for last month
$date = (Get-Date).ToUniversalTime().AddMonths(-1)
$startofmonth = Get-Date $date -day 1 -Hour 0 -Minute 0 -Second 0
$midmonth = Get-Date $date -Day 15 -Hour 0 -Minute 0 -Second 0
$endofmonth = (($startofmonth).AddMonths(1).AddSeconds(-1))

## stores job data
$str = @()
$tracked =@()
## get all subscriptions in tenancy
$subscriptions = (Get-AzureRMSubscription).Id


# loop through subs for all vaults in all subs
foreach($sub in $subscriptions){
    #loop through sub logic
    Select-AzureRMSubscription $sub
    $subName = (Get-AzureRMContext).Subscription.Name
    ## output to stdout
    Write-Host $subName -ForegroundColor Yellow

    # loop through vaults for backup jobs
    $vaults = Get-AzureRMRecoveryServicesVault
    foreach($vault in $vaults){
        # vars.
    $f = 0
    $i = 0
    $count = 0
    $first = $null
    # set the current vault
    Set-AzureRMREcoveryServicesVaultContext -Vault $vault
    
    # logic to calculate dates and check jobs 
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
            $str += $obj
            $tracked += $failed
    }

    # write to stdout
    Write-Host $vault.Name -ForegroundColor Blue
    Write-Host "Failed Jobs $f"
    Write-Host "Successful Jobs $total"
    Write-Host "All Jobs $count"
    

    ## failed jobs
    $of += $f
    ## total jobs
    $ocount += $count
    ## total successful jobs
    $ototal += $total

}

}

## stdout
Write-Host "Failed Jobs" -ForegroundColor Red
$str | Select subscription,vName, metric, operation, status, vmName
Write-Host "Total Failed Jobs $of"
Write-Host "Total Successful Jobs $ototal"
Write-Host "Total Jobs $ocount"

## all failed jobs exported to csv in script location
$tracked | Export-Csv -Path ".\failed.csv"