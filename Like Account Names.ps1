$name = Read-Host -Prompt "Please enter the username"


$usercheck = Get-ADUser -Filter {SamAccountName -eq $name}

get-member $usercheck  