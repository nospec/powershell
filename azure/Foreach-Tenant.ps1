# get all subs
$tenant = (Get-AzureRMSubscription).Id

foreach($input in $tenant){
    Select-AzureRmSubscription $input
    Write-Host "Logged into $input"
}