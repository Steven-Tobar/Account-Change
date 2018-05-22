$name = Read-Host -Prompt "username"
$validuser = Get-ADUser -Filter {SAMaccountName -eq $name} 
 
while($validuser -ne $null)
{
  "This account exists"
}
else 
{
 "This account does not exist"

}







<#Do

{
    $validuser = Get-ADUser -Filter {SAMaccountName -eq $name}
    
    $userproperties = get-aduser $name -properties * | Select-Object -Property accountexpirationdate,lockedout,passwordexpired,passwordlastset,whencreated
    "$name's properties:" 
    echo $userproperties
           
    
}
while ($validuser -ne $null)

#>