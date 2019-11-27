$file = Import-Csv -Path .\ipresources.csv

$subscriptions = (Get-AzureRMSubscription).Name

foreach($sub in $subscriptions){
    Select-AzureRMSubscription $sub
    $items = $file.Where{$_.Subscription -eq "$sub"}

    foreach($item in $items){
        $name = $item.Name
        $group = $item.ResourceGroupName
        $st = $item.Subscription

        Write-Host "$name in $group for $st"

        Get-AzureRMPublicIpAddress -ResourceGroupName $group -Name $name | Select * > $name
    }
}