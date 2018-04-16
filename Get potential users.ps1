cls

$username = Read-Host -Prompt "Please enter a username in the format first.name"


$firstname,$lastname = $username.Split(".")

$fullname = $firstname + " " + $lastname

echo $fullname

$verifyuser = Get-ADUser -filter {name -eq $fullname} |select -expandproperty samaccountname 

echo "Their username is actually: $verifyuser"