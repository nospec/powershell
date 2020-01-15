$fam = "CNI Azure - MPN Bulk Credit"
$fam1 = "CNI Managed Services"

$sub = Get-AzureRMSubscription

foreach($su in $sub){
    Select-AzureRmSubscription $su.Id
    if($su.Name -eq $fam -Or $su.Name -like $fam1){
        write-host hi
    }
    else {
        write-host yo
        write-host $su.Name
    }
}