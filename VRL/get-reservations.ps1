$ids = (Get-AzReservationOrderId).AppliedReservationOrderId
$ids = $ids -replace ".*/"
$yeet = @()

$subNa = (Get-AzContext).Subscription.Name

foreach($id in $ids){
    $id
    $res = Get-AzReservation -ReservationOrderId $id

    if($res){
        $obj = New-Object psobject -Propert @{
            Sub = $subNa
            Sku = $res.Sku
            ResourceType = $res.ReservedResourceType
            Quantity = $res.Quantity
            Location = $res.Location
            DisplayName = $res.DisplayName
            EffectiveDate = $res.EffectiveDateTime
            ExpiryDate = $res.ExpiryDate
        }
        $yeet += $obj
    }

}
$yeet | Select DisplayName, Sku, Quantity, Sub, Location, ResourceType, EffectiveDate, ExpiryDate