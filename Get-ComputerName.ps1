function Get-ComputerName{
    
    param(
        [Parameter(Mandatory=$true)]
        $username = 'username'
        
    )
    $aduser=get-aduser -Identity $username -properties name
    $computer=get-adcomputer -filter * -properties ManagedBy | Where-Object { $_.managedby -eq $aduser.distinguishedname } 
    $property=@{
    'Username' = $aduser.Name;
    'Computer' = $computer.Name;
    }
    $obj=new-object -TypeName PSObject -Property $property
    Write-Output $obj | Format-table username,computer

}