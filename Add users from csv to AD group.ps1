Import-Module ActiveDirectory
$csvpath = "Enter CSV Path"
  $adGroup = Read-Host "Enter AD Group Name"
Import-Csv $csvpath | ForEach-Object {
 $samAccountName = $_."samAccountName"
 Add-ADGroupMember $adGroup $samAccountName;
 Write-Host "- "$samAccountName" added to "$adGroup
}
