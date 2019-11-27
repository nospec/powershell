###Create array###
$displayData = @()

###Connect and access each subscription###
# Connect-AzureRmAccount
#$subscription = get-AzureRmSubscription 
# Select-AzureRmSubscription -Subscription 

 

#foreach($sub in $subscription){

$sqlServers = Get-AzureRMSqlServer

foreach($sql in $sqlServers){
    $name = $sql.ServerName
    $group = $sql.ResourceGroupName    
    $sqlfwr = Get-AzureRmSqlServerFirewallRule -ServerName $name -ResourceGroupName $group 
    
    
    foreach($fwR in $sqlfwr){
        $obj = new-object psobject -Property @{
        FirewallRuleName = $fwr.FirewallRuleName
        StartIpAddress = $fwr.StartIpAddress
        EndIpAddress = $fwr.EndIpAddress
        ServerName = $sql.ServerName
    }

        $displayData += $obj
}

 }

 $displayData | Select ServerName, FirewallRuleName, StartIpAddress, EndIpAddress