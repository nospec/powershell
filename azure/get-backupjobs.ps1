# $subs = (Get-AzureRmSubscription).Id

# foreach($sub in $subs){
#     Select-AzureRMSubscription $sub
    $vaults = Get-AzureRMRecoveryServicesVault
    $i = 0
    $t = 0
    $first = $null
    $second = $null

    foreach($vault in $vaults){
        Set-AzureRMRecoveryServicesVaultContext -Vault $vault

            # $fr = Get-Date -Year 2019 -Month 10 -Day 1 -Hour 0 -Minute 0 -Second 0 -MilliSecond 0
            # $fr = $fr.ToUniversalTime()

            # $t0 = Get-Date -Year 2019 -Month 10 -Day 31 -Hour 0 -Minute 0 -Second 0 -MilliSecond 0
            # $t0 = $t0.ToUniversalTime()

            $fr = Get-Date -Year 2019 -Month 10 -Day 1 -Hour 0 -Minute 0 -Second 0 -MilliSecond 0
            $fr = $fr.ToUniversalTime()

            $t0 = Get-Date -Year 2019 -Month 10 -Day 15 -Hour 0 -Minute 0 -Second 0 -MilliSecond 0
            $t0 = $t0.ToUniversalTime()
           
        # Get-AzureRMRecoveryServicesBackupJob -From (Get-Date).AddDays(-35).ToUniversalTime() -To (Get-Date).AddDays(-5).ToUniversalTime() 
        $first += Get-AzureRMRecoveryServicesBackupJob -From $fr -To $t0

        # $result = $first | ? {$_.Status -notmatch 'Completed'} | Select WorkloadName,Status,JobID

        # limited to 30 days so i split the work into two runs

            $fr1 = Get-Date -Year 2019 -Month 10 -Day 15 -Hour 0 -Minute 0 -Second 0 -MilliSecond 0
            $fr1 = $fr1.ToUniversalTime()

            $t01 = Get-Date -Year 2019 -Month 11 -Day 1 -Hour 0 -Minute 0 -Second 0 -MilliSecond 0
            $t01 = $t01.ToUniversalTime()

        $second += Get-AzureRMRecoveryServicesBackupJob -From $fr1 -To $t01

        # $result += $second | ? {$_.Status -notmatch 'Completed'} | Select WorkloadName,Status,JobID
        # $second | ? { $i++ }

        # $result
        $first | ? { $i++ }
        $second | ? { $t++ }
    }

    $first
    $second

    Write-Host "Total Jobs in first $i"
    Write-Host "Total Jobs in second $t"

# }