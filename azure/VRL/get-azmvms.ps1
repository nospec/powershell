$names = Get-AzVM
$count = $names | measure | select count
$count
foreach($n in $names){
        ($n).LicenseType
        $i++
}
$i