# Connect-AzureRmAccount

# Select-AzureRmSubscription "DHHS Prod MGMT"

# assign tags object with tags to assign to resource
$tags = @{
    Tag1 = "dhhs";
    Tag2 = "intfe";
    Tag3 = "intfe";
    Tag4 = "prod";
    Tag5 = "7443";
    Monitoring = "";
    Chargeback = "intfe-7443"
}

$rg = "p-auea-rg-intfe"

# assign all resources in an rg to a variable
$resources = Get-AzureRmResource -ResourceGroupName $rg

# for each resource in the variable
# overwrite all tags with the tags in the above $tags object
foreach($resource in $resources){
    # business end
    # NOTE THIS WILL OVER WRITE ALL CURRENT TAGS WITH THE TAGS ABOVE
    Set-AzureRmResource -Tag $tags -ResourceID $resource.Id -Force
}

# this is purely for confirmation 
# once the tags are assigned this will refresh resource properties
$newresources = Get-AzureRMResource -ResourceGroupName $rg

#display the business end of the resources
# i want to know if the tags are assigned
foreach($r in $newresources){
    $r.Name
    $r.ResourceType
    $r.Tags
}

#DONE