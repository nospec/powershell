#Connect-AzureRMAccount

#Get-AzureRMSubscription

#Select-AzureRMSubscription -SubscriptionName ""

#$subName = (Get-AzureRmContext).Name



# $rgs = Get-AzureRMResourceGroup

# foreach($name in $rgs){
#     $tags = $name.Tags
#     Write-Host "Name: " $name.ResourceGroupName
#     Write-Host "Location: " $name.Location
#     foreach($tag in $tags){
#         Write-Host $tag.Key $tag.Value
#     }
# }

#Create empty array object
$returnObj = @()

#Create empty string for resoure tag hashtable conversion
$resourceTagString = ""

#Loops for each subscription
foreach($sub in $subscriptions)
{
    
    select-AzSubscription $sub.SubscriptionID

    #Get all resource groups
    $resources =  (Get-AzResourceGroup)
   
    #Iterate through each resource  and store values in an object
    foreach($item in $resources)
    {
        $Tags = $item.Tags
        
        #Loop through has table for tags and append string
        if ($Tags -ne $null) {
            $Tags.GetEnumerator() | % { $resourceTagString += $_.Key + ":" + $_.Value + ";" 
        }

        }
        else {

            $TagsAsString = "NULL"
        }

        #Create new object for each property
        $obj = new-object psobject -Property @{
            selectedSub = $sub.name
            resourceGroupName = $item.resourceGroupName
            resourceLocation = $item.location
            resourceName = $item.name
            resourceType = $item.resourceType
            resourceTag =  $resourceTagString
    
        }

        $returnObj += $obj 

        #Empty the tag string array
        $resourceTagString = ""
     
    }
    #Shows output in screen
    $returnObj | Format-Table selectedSub, resourceGroupName, resourceLocation,resourceName,resourceType,resourceTag

    #Export to CSV
    $returnObj | Select-Object -Property selectedSub, resourceGroupName,resourceName,resourceType, resourceLocation,resourceTag | export-csv All-ResourceTags.csv -NoTypeInformation
    
}
