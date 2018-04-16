$user = "steven.tobar"

$firstname,$lastname =$user.Split(".")

$fullname = $firstname + " " + $lastname

$verifyuser = Get-ADUser -filter {name -eq $fullname} |select -expandproperty samaccountname 

echo "The user's username is actually: $verifyuser"