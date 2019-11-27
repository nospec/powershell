Connect-AzureRmAccount

$ResourceGroups = Get-AzureRmResourceGroup

Get-AzureRmResource | Select Name,ResourceGroupName

foreach($name in $ResourceGroups.ResourceGroupName)

$RGs = (Get-AzureRmResourceGroup -Name $Name).Tags 

Get-AzureRmResource | Select ResourceGroupName,Name,ResourceType,Tags